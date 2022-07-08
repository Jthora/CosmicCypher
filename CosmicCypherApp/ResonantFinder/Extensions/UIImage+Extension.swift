//
//  UIImage+Extension.swift
//  EarthquakeFinder
//
//  Created by Jordan Trana on 8/19/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import UIKit
import CoreGraphics
import Accelerate

extension UIImage {
    public func imageRotatedByDegrees(degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(self.cgImage!, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }


    public func fixedOrientation() -> UIImage {
        if imageOrientation == UIImage.Orientation.up {
            return self
        }

        var transform: CGAffineTransform = CGAffineTransform.identity

        switch imageOrientation {
        case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi/2)
            break
        case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -CGFloat.pi/2)
            break
        case UIImage.Orientation.up, UIImage.Orientation.upMirrored:
            break
        }

        switch imageOrientation {
        case UIImage.Orientation.upMirrored, UIImage.Orientation.downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImage.Orientation.leftMirrored, UIImage.Orientation.rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImage.Orientation.up, UIImage.Orientation.down, UIImage.Orientation.left, UIImage.Orientation.right:
            break
        }

        let ctx: CGContext = CGContext(data: nil,
                                       width: Int(size.width),
                                       height: Int(size.height),
                                       bitsPerComponent: self.cgImage!.bitsPerComponent,
                                       bytesPerRow: 0,
                                       space: self.cgImage!.colorSpace!,
                                       bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

        ctx.concatenate(transform)

        switch imageOrientation {
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored, UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }

        let cgImage: CGImage = ctx.makeImage()!

        return UIImage(cgImage: cgImage)
    }
}

@available(iOS 10.0, *)
extension UIImage {
    func removingAlpha() -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.opaque = true // removes Alpha Channel
        format.scale = scale // keeps original image scale
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}


extension UIImage {

    public enum Error: Swift.Error {
        case cgImageCreationFailed
        case imageResizingFailed
    }

    /// Resize image from given size.
    ///
    /// - Parameter maxPixels: Max pixels in the output image. If input image pixel count is less than maxPixels value then it won'n be risezed.
    /// - Parameter resizeTechnique: Technique for image resizing: UIKit / CoreImage / CoreGraphics / ImageIO / Accelerate.
    /// - Returns: Resized image.
    public func resized(maxPixels: Int,
                       with resizeTechnique: CGImage.ResizeTechnique) throws -> UIImage {
        let maxPixels = CGFloat(maxPixels)
        let pixelCount = self.size.width
                       * self.size.height
        if pixelCount > maxPixels {
            let sizeRatio = sqrt(maxPixels / pixelCount)
            let newWidth = self.size.width
                         * sizeRatio
            let newHeight = self.size.height
                          * sizeRatio
            let newSize = CGSize(width: newWidth,
                                 height: newHeight)
            return try self.resized(to: newSize,
                                    with: resizeTechnique)
        }
        return self
    }
    
    /// Resize image from given size.
    ///
    /// - Parameter newSize: Size of the image output.
    /// - Parameter resizeTechnique: Technique for image resizing: UIKit / CoreImage / CoreGraphics / ImageIO / Accelerate.
    /// - Returns: Resized image.
    public func resized(to newSize: CGSize,
                       with resizeTechnique: CGImage.ResizeTechnique) throws -> UIImage {
        if resizeTechnique == .uiKit {
            return try self.resizeWithUIKit(to: newSize)
        } else {
            guard let cgImage = self.cgImage
            else { throw Error.cgImageCreationFailed }

            return try .init(cgImage: cgImage.resized(to: newSize,
                                                      with: resizeTechnique))
        }
    }
    
    // MARK: - UIKit

    private func resizeWithUIKit(to newSize: CGSize) throws -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize,
                                               true,
                                               1.0)
        self.draw(in: .init(origin: .zero,
                            size: newSize))
        guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        else { throw Error.imageResizingFailed }
        UIGraphicsEndImageContext()
        
        return resizedImage
    }

}

//
//  ImageDataConverter.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/21/23.
//

import SpriteKit
import Metal
import MetalKit
import Foundation

class ImageDataConverter {
    
    // Enum to represent the supported formats
    enum ImageFormat {
        case skTexture
        case mtlTexture
        case uiImage
        case data
    }
    
    // Static function to convert between various formats using the provided enum
    static func convertImageToUInt8Array(inputImage: Any,
                                         format: ImageFormat,
                                         width: Int,
                                         height: Int,
                                         device: MTLDevice?) -> [UInt8]? {
        switch format {
        case .skTexture:
            if let texture = inputImage as? SKTexture {
                return convertSKTextureToUInt8Array(texture: texture, width: width, height: height)
            }
        case .mtlTexture:
            if let texture = inputImage as? MTLTexture {
                return convertMTLTextureToUInt8Array(texture: texture, width: width, height: height)
            }
        case .uiImage:
            if let image = inputImage as? UIImage {
                return convertUIImageToUInt8Array(image: image)
            }
        case .data:
            if let data = inputImage as? Data {
                return convertDataToUInt8Array(data: data)
            }
        }

        return nil
    }
    
    // Static function to convert from UInt8 array to various formats using the provided enum
        static func convertUInt8ArrayToImage(uint8Array: [UInt8],
                                             format: ImageFormat,
                                             width: Int,
                                             height: Int,
                                             device: MTLDevice?) -> Any? {
            switch format {
            case .skTexture:
                guard let texture = convertToSKTexture(uint8Array: uint8Array, width: width, height: height) else {
                    return nil
                }
                return texture

            case .mtlTexture:
                guard let device = device,
                      let texture = convertToMTLTexture(uint8Array: uint8Array, width: width, height: height, device: device) else {
                    return nil
                }
                return texture

            case .uiImage:
                guard let image = convertToUIImage(uint8Array: uint8Array, width: width, height: height) else {
                    return nil
                }
                return image

            case .data:
                let data = Data(uint8Array)
                return data
            }
        }
    
    // Convert SKTexture to UInt8 array
    static func convertSKTextureToUInt8Array(texture: SKTexture, width: Int, height: Int) -> [UInt8]? {
        let cgImage = texture.cgImage()

        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let totalBytes = width * height * bytesPerPixel

        var imageData = [UInt8](repeating: 0, count: totalBytes)

        guard let context = CGContext(
            data: &imageData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return nil
        }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        return imageData
    }

    // Convert UInt8 array to SKTexture
    static func convertToSKTexture(uint8Array: [UInt8], width: Int, height: Int) -> SKTexture? {
        let texture = SKTexture(data: Data(uint8Array), size: CGSize(width: width, height: height))
        return texture
    }

    // Static function to convert UInt8 array to MTLTexture
    static func convertToMTLTexture(uint8Array: [UInt8], width: Int, height: Int, device: MTLDevice) -> MTLTexture? {
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm, width: width, height: height, mipmapped: false)
        
        guard let texture = device.makeTexture(descriptor: textureDescriptor) else {
            return nil
        }
        
        let region = MTLRegionMake2D(0, 0, width, height)
        texture.replace(region: region, mipmapLevel: 0, withBytes: uint8Array, bytesPerRow: width * 4)
        
        return texture
    }
    
    // Static function to convert MTLTexture to UInt8 array
    static func convertMTLTextureToUInt8Array(texture: MTLTexture, width: Int, height: Int) -> [UInt8]? {
        // Create a buffer to hold the image data
        var imageData = [UInt8](repeating: 0, count: width * height * 4)

        // Get the texture data
        let region = MTLRegionMake2D(0, 0, width, height)
        texture.getBytes(&imageData, bytesPerRow: width * 4, from: region, mipmapLevel: 0)

        return imageData
    }
    
    // Static function to convert UInt8 array to UIImage
    static func convertToUIImage(uint8Array: [UInt8], width: Int, height: Int) -> UIImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel

        guard let dataProvider = CGDataProvider(data: NSData(bytes: uint8Array, length: uint8Array.count)) else {
            return nil
        }

        guard let cgImage = CGImage(
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bytesPerPixel * bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue),
            provider: dataProvider,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        ) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
    
    // Static function to convert UIImage to UInt8 array
    static func convertUIImageToUInt8Array(image: UIImage) -> [UInt8]? {
        guard let cgImage = image.cgImage else {
            return nil
        }

        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let totalBytes = width * height * bytesPerPixel

        var imageData = [UInt8](repeating: 0, count: totalBytes)

        guard let context = CGContext(
            data: &imageData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.noneSkipLast.rawValue
        ) else {
            return nil
        }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        return imageData
    }

    // Static function to convert UInt8 array to Data
    static func convertToData(uint8Array: [UInt8]) -> Data {
        return Data(bytes: uint8Array, count: uint8Array.count)
    }

    // Static function to convert Data to UInt8 array
    static func convertDataToUInt8Array(data: Data) -> [UInt8] {
        return [UInt8](data)
    }
}


extension MTLTexture {
    func toSKTexture(device: MTLDevice) -> SKTexture? {
        // Create a texture descriptor with the same size and format as the MTLTexture
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: self.pixelFormat,
            width: self.width,
            height: self.height,
            mipmapped: false
        )

        // Create a CPU-accessible buffer with enough space for the texture data
        let bufferSize = self.width * self.height * 4 // Assuming RGBA8 format
        guard let buffer = device.makeBuffer(length: bufferSize, options: []) else {
            return nil
        }

        // Create a command queue
        let commandQueue = device.makeCommandQueue()

        // Create a command buffer
        guard let commandBuffer = commandQueue?.makeCommandBuffer() else {
            return nil
        }

        // Create a blit command encoder to copy the texture data to the buffer
        let blitEncoder = commandBuffer.makeBlitCommandEncoder()
        blitEncoder?.copy(from: self, sourceSlice: 0, sourceLevel: 0, sourceOrigin: MTLOriginMake(0, 0, 0), sourceSize: MTLSizeMake(self.width, self.height, self.depth), to: buffer, destinationOffset: 0, destinationBytesPerRow: self.width * 4, destinationBytesPerImage: 0)
        blitEncoder?.endEncoding()

        // Commit the command buffer
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()

        // Create a Data object from the CPU buffer
        let data = Data(bytesNoCopy: buffer.contents(), count: bufferSize, deallocator: .none)

        // Create an SKTexture from the Data
        let texture = SKTexture(data: data, size: CGSize(width: self.width, height: self.height))
        
        return texture
    }
}




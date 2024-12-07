//
//  TextureGeneration.swift
//  EarthquakeFinder
//
//  Created by Jordan Trana on 8/20/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import UIKit

func buildHueCircle(in rect: CGRect, radius: CGFloat, scale: CGFloat = UIScreen.main.scale) -> CGImage {
    let width = Int(rect.size.width * scale)
    let height = Int(rect.size.height * scale)
    let center = CGPoint(x: width / 2, y: height / 2)

    let space = CGColorSpaceCreateDeviceRGB()
    let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: space, bitmapInfo: Pixel.bitmapInfo)!

    let buffer = context.data!

    let pixels = buffer.bindMemory(to: Pixel.self, capacity: width * height)
    var pixel: Pixel
    for y in 0 ..< height {
        for x in 0 ..< width {
            let angle = fmod(atan2(CGFloat(x) - center.x, CGFloat(y) - center.y) + 2 * .pi, 2 * .pi)
            let distance = hypot(CGFloat(x) - center.x, CGFloat(y) - center.y)

            let value = UIColor(hue: angle / 2 / .pi, saturation: 1, brightness: 1, alpha: 1)

            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            value.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

            if distance <= (radius * scale) {
                pixel = Pixel(red:   UInt8(red * 255),
                              green: UInt8(green * 255),
                              blue:  UInt8(blue * 255),
                              alpha: UInt8(alpha * 255))
            } else {
                pixel = Pixel(red: 255, green: 255, blue: 255, alpha: 0)
            }
            pixels[y * width + x] = pixel
        }
    }

    return context.makeImage()!
}


func buildAnglularCircleMask(in rect: CGRect, radius: CGFloat, degrees:CGFloat, scale: CGFloat = 1) -> CGImage {
    let width = Int(rect.size.width * scale)
    let height = Int(rect.size.height * scale)
    let center = CGPoint(x: width / 2, y: height / 2)
    let ratio = degrees / 360

    let space = CGColorSpaceCreateDeviceGray()
    let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: space, bitmapInfo: CGImageAlphaInfo.none.rawValue)!

    let buffer = context.data!

    let pixels = buffer.bindMemory(to: Pixel.self, capacity: width * height)
    var pixel: Pixel
    for y in 0 ..< height {
        for x in 0 ..< width {
            let angle = fmod(atan2(CGFloat(x) - center.x, CGFloat(y) - center.y) + 2 * .pi, 2 * .pi)
            let distance = hypot(CGFloat(x) - center.x, CGFloat(y) - center.y)

            // deg 360 == rad 3.14 * 2
            // max angle = .pi * 2
            // normalized means: 0 to 1
            
            let normalizedAngle = angle / 2 / .pi
            
            let brightness = max(0,(normalizedAngle/ratio)-((1-ratio)/ratio))
            let value = UIColor(hue: 0, saturation: 1, brightness: brightness, alpha: 1)

            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            value.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

            if distance <= (radius * scale) {
                pixel = Pixel(red:   UInt8(red * 255),
                              green: UInt8(green * 255),
                              blue:  UInt8(blue * 255),
                              alpha: UInt8(alpha * 255))
            } else {
                pixel = Pixel(red: 255, green: 255, blue: 255, alpha: 0)
            }
            pixels[y * width + x] = pixel
        }
    }

    return context.makeImage()!
}

struct Pixel: Equatable {
    private var rgba: UInt32

    var red: UInt8 {
        return UInt8((rgba >> 24) & 255)
    }

    var green: UInt8 {
        return UInt8((rgba >> 16) & 255)
    }

    var blue: UInt8 {
        return UInt8((rgba >> 8) & 255)
    }

    var alpha: UInt8 {
        return UInt8((rgba >> 0) & 255)
    }

    init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        rgba = (UInt32(red) << 24) | (UInt32(green) << 16) | (UInt32(blue) << 8) | (UInt32(alpha) << 0)
    }

    static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue

    static func ==(lhs: Pixel, rhs: Pixel) -> Bool {
        return lhs.rgba == rhs.rgba
    }
}

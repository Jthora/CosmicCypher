//
//  TimeStreamFrameBuffer.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/23/23.
//

import UIKit
import Metal
import SwiftAA

typealias TimeStreamFrameBuffer = MTLTexture


extension TimeStreamFrameBuffer {
    
    func draw(pixel rgby: RGBYPixel) {
        draw(pixel: rgby.rgba)
    }
    
    func draw(pixel rgba: RGBAPixel) {
        // Ensure that x and y coordinates are within the bounds of the frame buffer
        guard rgba.px >= 0 && rgba.px < Int(self.width) && rgba.py >= 0 && rgba.py < Int(self.height) else {
            return
        }
        
        // Create a region of size 1x1 to update only the specified pixel
        let region = MTLRegion(origin: MTLOrigin(x: rgba.px, y: rgba.py, z: 0), size: MTLSize(width: 1, height: 1, depth: 1))
        
        // Prepare the pixel data
        var pixelData = [UInt8](repeating: 0, count: 4)
        pixelData[0] = rgba.r
        pixelData[1] = rgba.g
        pixelData[2] = rgba.b
        pixelData[3] = rgba.a
        
        // Update the frame buffer with the new pixel data
        self.replace(region: region, mipmapLevel: 0, withBytes: pixelData, bytesPerRow: 4)
    }
}

struct RGBAPixel {
    let r: UInt8
    let g: UInt8
    let b: UInt8
    let a: UInt8
    let px: Int
    let py: Int
    
    var color:UIColor {
        return UIColor(red: CGFloat(r)/255,
                       green: CGFloat(g)/255,
                       blue: CGFloat(b)/255,
                       alpha: CGFloat(a)/255)
    }
}

struct RGBYPixel {
    let r: UInt8
    let g: UInt8
    let b: UInt8
    let y: UInt8
    let px: Int
    let py: Int
    
    var rgba:RGBAPixel {
        // Natural Harmonics Init
        RGBAPixel(r: UInt8(min(r + y, 255)),
                  g: UInt8(min(g + y, 255)),
                  b: UInt8(b * 255),
                  a: 1,
                  px: px,
                  py: py)
    }
    
    init(degrees:Double, px:Int, py:Int, solidColors:Bool = false) {
        
        // set pixel X,Y position
        self.px = px
        self.py = py
            
        // 0 to 120 (red 0.5 to red 0.5)
        var trineDegrees = Float(degrees.truncatingRemainder(dividingBy: 120))
        
        if solidColors {
            
            if trineDegrees >= 0 && trineDegrees < 30 {
                // Fire
                r = 255
                g = 0
                b = 0
                y = 0
            } else if trineDegrees >= 30 && trineDegrees < 60 {
                // Earth
                r = 0
                g = 255
                b = 0
                y = 0
            } else if trineDegrees >= 60 && trineDegrees < 90 {
                // Air
                r = 0
                g = 0
                b = 0
                y = 255
            } else if trineDegrees >= 90 && trineDegrees < 120 {
                // Water
                r = 0
                g = 0
                b = 255
                y = 0
            } else {
                // ERROR
                r = 0
                g = 0
                b = 0
                y = 0
                print("⚠️ ERROR: trineDegrees(\(trineDegrees)) is out of bounds for RGBYPixel")
            }
            
        } else {
            
             // -15 to 105 (offset origin to Red = 1.0)
            trineDegrees -= 15

            // 0 to 120 (red 1.0 to red 1.0)
            if trineDegrees < 0 {
                trineDegrees += 120
            }
            
            // Red
            if trineDegrees >= 0 && trineDegrees < 30 {
                r = UInt8((1-(trineDegrees/30))*255)
            } else if trineDegrees >= 90 && trineDegrees < 120 {
                let subDegrees = trineDegrees - 90
                r = UInt8((subDegrees/30)*255)
            } else {
                r = 0
            }
            
            // Green
            if trineDegrees >= 0 && trineDegrees < 60 {
                g = UInt8((1-fabsf(((trineDegrees/60)*2)-1))*255)
            } else {
                g = 0
            }
            
            // Yellow
            if trineDegrees >= 30 && trineDegrees < 90 {
                let subDegrees = trineDegrees - 30
                y = UInt8((1-fabsf(((subDegrees/60)*2)-1))*255)
            } else {
                y = 0
            }
            
            // Blue
            if trineDegrees >= 60 && trineDegrees < 120 {
                let subDegrees = trineDegrees - 60
                b = UInt8((1-fabsf(((subDegrees/60)*2)-1))*255)
            } else {
                b = 0
            }
        }
    }
}

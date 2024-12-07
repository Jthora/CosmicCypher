//
//  Color.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 12/6/20.
//

import UIKit

struct RGYBColor
{
    var red:CGFloat = 0
    var green:CGFloat = 0
    var yellow:CGFloat = 0
    var blue:CGFloat = 0
    
    init(degrees:Float, solidColors:Bool = false) {
        
            
            // 0 to 120 (red 0.5 to red 0.5)
            var trineDegrees = degrees.truncatingRemainder(dividingBy: 120)
        
        if solidColors {
            
            if trineDegrees >= 0 && trineDegrees < 30 {
                // Fire
                red = 1
            } else if trineDegrees >= 30 && trineDegrees < 60 {
                // Earth
                green = 1
            } else if trineDegrees >= 60 && trineDegrees < 90 {
                // Air
                yellow = 1
            } else if trineDegrees >= 90 && trineDegrees < 120 {
                // Water
                blue = 1
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
                red = CGFloat(1-(trineDegrees/30))
            }
            if trineDegrees >= 90 && trineDegrees < 120 {
                let subDegrees = trineDegrees - 90
                red = CGFloat(subDegrees/30)
            }
            
            // Green
            if trineDegrees >= 0 && trineDegrees < 60 {
                green = CGFloat(1-fabsf(((trineDegrees/60)*2)-1))
            }
            
            // Yellow
            if trineDegrees >= 30 && trineDegrees < 90 {
                let subDegrees = trineDegrees - 30
                yellow = CGFloat(1-fabsf(((subDegrees/60)*2)-1))
            }
            
            // Blue
            if trineDegrees >= 60 && trineDegrees < 120 {
                let subDegrees = trineDegrees - 60
                blue = CGFloat(1-fabsf(((subDegrees/60)*2)-1))
            }
        }
        
    }
}

struct RGBAColor
{
    var Red:   UInt8 = 0
    var Green: UInt8 = 0
    var Blue:  UInt8 = 0
    var Alpha: UInt8 = 255
    
    init(degrees:Float, invert:Bool = false, solidColors:Bool = false) {
        
        let rgybColor = RGYBColor(degrees: degrees, solidColors: solidColors)
        
        Red = UInt8(min((rgybColor.red * 255) + (rgybColor.yellow * 255), 255))
        Green = UInt8(min((rgybColor.green * 255) + (rgybColor.yellow * 255), 255))
        Blue = UInt8(rgybColor.blue * 255)
        
        if invert {
            Red = 255 - Red
            Green = 255 - Green
            Blue = 255 - Blue
        }
    }
    
    init(red:UInt8 = 0, green:UInt8 = 0, blue:UInt8 = 0, alpha:UInt8 = 255) {
        Red = red
        Green = green
        Blue = blue
        Alpha = alpha
    }
    
    static var black:RGBAColor {
        return RGBAColor(red: 0, green: 0, blue: 0, alpha: 255)
    }
    
    static var white:RGBAColor {
        return RGBAColor(red: 255, green: 255, blue: 255, alpha: 255)
    }
    
    static var clear:RGBAColor {
        return RGBAColor(red: 255, green: 255, blue: 255, alpha: 0)
    }
}

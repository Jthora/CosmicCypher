//
//  RGYBColor.swift
//  PsionicTimeMap_ImageProducer
//
//  Created by Jordan Trana on 1/15/22.
//  Copyright © 2022 Jordan Trana. All rights reserved.
//

import Foundation
import SwiftUI

// Red Green Yellow Blue Color
struct RGYBColor
{
    var red:CGFloat = 0
    var green:CGFloat = 0
    var yellow:CGFloat = 0
    var blue:CGFloat = 0
    
    init(r: UInt8, g:UInt8, b:UInt8, y:UInt8) {
        red = CGFloat(r)/255.0
        green = CGFloat(g)/255.0
        blue = CGFloat(b)/255.0
        yellow = CGFloat(y)/255.0
    }
    
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

// Red Green Blue Alpha Color
struct RGBAColor
{
    // Red 0-255
    var Red:   UInt8 = 0
    
    // Red 0-1
    var r:Double {
        get {
            return Double(Red)/255
        }
        set {
            let red = max(min(newValue,0),1)
            Red = UInt8(red * 255)
        }
    }
    
    // Green 0-255
    var Green: UInt8 = 0
    
    // Green 0-1
    var g:Double {
        get {
            return Double(Green)/255
        }
        set {
            let green = max(min(newValue,0),1)
            Green = UInt8(green * 255)
        }
    }
    
    // Blue 0-255
    var Blue:  UInt8 = 0
    
    // Blue 0-1
    var b:Double {
        get {
            return Double(Green)/255
        }
        set {
            let blue = max(min(newValue,0),1)
            Green = UInt8(blue * 255)
        }
    }
    
    // Alpha 0-255
    var Alpha: UInt8 = 255
    
    // Alpha 0-1
    var a:Double {
        get {
            return Double(Alpha)/255
        }
        set {
            let alpha = max(min(newValue,0),1)
            Alpha = UInt8(alpha * 255)
        }
    }
    
    
    // Natural Harmonics Init
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
    
    // RGBA Init
    init(red:UInt8 = 0, green:UInt8 = 0, blue:UInt8 = 0, alpha:UInt8 = 255) {
        Red = red
        Green = green
        Blue = blue
        Alpha = alpha
    }
    
    // Hue
    var hue:Double {
        get {
            let min = min(min(r,g),b)
            let max = max(max(r,g),b)
            
            if min == max {
                return 0
            }
            
            var hue:Double = 0
            if max == r {
                hue = (g-b) / (max-min)
            } else if max == g {
                hue = (b-r) / (max-min)
            } else {
                hue = (r-g) / (max-min)
            }
            
            // Base 360 for compatibility with Degrees
            hue = hue * 60
            if (hue < 0) {
                hue = hue + 360
            }
            
            return hue
        }
    }
    
    // Black Color
    static var black:RGBAColor {
        return RGBAColor(red: 0, green: 0, blue: 0, alpha: 255)
    }
    
    // White Color
    static var white:RGBAColor {
        return RGBAColor(red: 255, green: 255, blue: 255, alpha: 255)
    }
    
    // Transparent
    static var clear:RGBAColor {
        return RGBAColor(red: 255, green: 255, blue: 255, alpha: 0)
    }
    
    // Alpha Channel
    static func alphascale(currentValue:Double, minValue:Double, maxValue:Double) -> RGBAColor {
        let relativeValueRange = minValue - maxValue
        let relativeValue = currentValue - minValue
        return alphascale(opacity: relativeValue/relativeValueRange)
    }
    static func alphascale(opacity:Double) -> RGBAColor {
        return RGBAColor(red: 0,
                         green: 0,
                         blue: 0,
                         alpha: UInt8(Double(opacity/255)))
    }
    
    // Greyscale
    static func greyscale(currentValue:Double, minValue:Double, maxValue:Double) -> RGBAColor {
        let relativeValueRange = minValue - maxValue
        let relativeValue = currentValue - minValue
        return greyscale(brightness: relativeValue/relativeValueRange)
    }
    static func greyscale(brightness:Double) -> RGBAColor {
        return RGBAColor(red: UInt8(Double(brightness/255)),
                         green: UInt8(Double(brightness/255)),
                         blue: UInt8(Double(brightness/255)),
                         alpha: 255)
    }
    
    // Changes the RGB/HEX temporarily to a HSL-Value, modifies that value
    // and changes it back to RGB/HEX.

    mutating func changeHue(degree: Double){
        let hsl = hsl
        var h = hsl.h
        h += degree
        if (h > 360) {
            h -= 360
        }
        else if (h < 0) {
            h += 360
        }
        let n = changeHSL(h: h, s: hsl.s, l: hsl.l)
        self.Red = n.Red
        self.Green = n.Green
        self.Blue = n.Blue
        self.Alpha = n.Alpha
    }
    
    var hsl:HSLColor {
        get {
            var r = self.r,
                g = self.g,
                b = self.b,
                cMax: Double = max(r, max(g, b)),
                cMin: Double = min(r, max(g, b)),
                delta: Double = cMax - cMin,
                l: Double = (cMax + cMin) / 2,
                h: Double = 0,
                s: Double = 0;

            if (delta == 0) {
                h = 0;
            }
            else if (cMax == r) {
                h = 60 * (((g - b) / delta).truncatingRemainder(dividingBy: 6));
            }
            else if (cMax == g) {
                h = 60 * (((b - r) / delta) + 2);
            }
            else {
                h = 60 * (((r - g) / delta) + 4);
            }

            if (delta == 0) {
                s = 0;
            }
            else {
                s = (delta/(1-abs(2*l - 1)))
            }

            return HSLColor(h: h, s: s, l: l)
        }
        set {
            let n = changeHSL(newValue)
            self.Red = n.Red
            self.Green = n.Green
            self.Blue = n.Blue
            self.Alpha = n.Alpha
        }
    }

    // Set HSL
    func changeHSL(_ hsl:HSLColor) -> RGBAColor { return changeHSL(h: hsl.h, s: hsl.s, l: hsl.l) }
    func changeHSL(h: Double, s: Double, l: Double) -> RGBAColor {
        var c: Double = (1 - abs(2 * l - 1)) * s,
            x: Double = c * ( 1 - abs((h / 60 ).truncatingRemainder(dividingBy: 2) - 1 )),
            m: Double = l - c / 2,
            r: Double = r,
            g: Double = g,
            b: Double = b

        if (h < 60) {
            r = c;
            g = x;
            b = 0;
        }
        else if (h < 120) {
            r = x;
            g = c;
            b = 0;
        }
        else if (h < 180) {
            r = 0;
            g = c;
            b = x;
        }
        else if (h < 240) {
            r = 0;
            g = x;
            b = c;
        }
        else if (h < 300) {
            r = x;
            g = 0;
            b = c;
        }
        else {
            r = c;
            g = 0;
            b = x;
        }

        return RGBAColor(red: normalizeRGB(r, m), green: normalizeRGB(g, m), blue: normalizeRGB(b, m), alpha: Alpha)
    }

    func normalizeRGB(_ color:Double, _ magnitude:Double) -> UInt8 {
        var c: Double = floor((color + magnitude) * 255);
        if (c < 0) {
            c = 0
        }
        return UInt8(color)
    }
    
    // HEX String
//    func rgbToHex(r :UInt8, g:UInt8, b:UInt8) {
//        return "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);
//    }
}

struct HSLColor {
    var h:Double
    var s:Double
    var l:Double
}


extension UIColor {
    static func from(_ elementReading: CosmicAlignment.ElementReading) -> UIColor {
        switch elementReading {
        case .fire: return .systemRed
        case .air: return .systemYellow
        case .water: return .systemBlue
        case .earth: return .systemGreen
        case .poly: return .white
        case .mono: return .white
        case .spirit: return UIColor(hue: 135/360.0, saturation: 0.5, brightness: 0.78, alpha: 1)
        case .light: return UIColor(hue: 210.0/360.0, saturation: 0.5, brightness: 1, alpha: 1)
        case .shadow: return UIColor(hue: 0, saturation: 0.5, brightness: 1, alpha: 1)
        case .soul: return UIColor(hue: 48/360.0, saturation: 0.5, brightness: 1, alpha: 1)
        case .core: return .systemOrange
        case .void: return .systemTeal
        case .alpha: return .systemBrown
        case .omega: return .systemPink
        case .order: return UIColor(hue: 100.0/360.0, saturation: 0.63, brightness: 0.87, alpha: 1)
        case .chaos: return .systemPurple
        }
    }
}

extension UIColor {
    var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h: h, s: s, b: b, a: a)
    }
}

extension UIColor {
    
    func change(hue: CGFloat? = nil,saturation: CGFloat? = nil, brightness: CGFloat? = nil) -> UIColor {
        return modifiedWith(additionalHue: hue,
                            additionalSaturation: saturation,
                            additionalBrightness: brightness)
    }

    func modifiedWith(additionalHue: CGFloat? = nil, additionalSaturation: CGFloat? = nil, additionalBrightness: CGFloat? = nil) -> UIColor {

        var currentHue: CGFloat = 0.0
        var currentSaturation: CGFloat = 0.0
        var currentBrigthness: CGFloat = 0.0
        var currentAlpha: CGFloat = 0.0

        if self.getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentAlpha){
            let hue = additionalHue != nil ? currentHue + additionalHue! : currentHue
            let saturation = additionalSaturation != nil ? currentHue + additionalSaturation! : currentHue
            let brightness = additionalBrightness != nil ? currentHue + additionalBrightness! : currentHue
            return UIColor(hue: hue,
                           saturation: saturation,
                           brightness: brightness,
                           alpha: currentAlpha)
        } else {
            return self
        }
    }
}

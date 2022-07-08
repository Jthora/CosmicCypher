//
//  PsionicImageGenerator.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 12/6/20.
//

import UIKit

class PsionicImageGenerator {
    
    static let main:PsionicImageGenerator = PsionicImageGenerator()
    
    var imageStrip:PsionoStreamImageStrip? = nil
    var renderAtAll:Bool = true
    var renderRetrogrades:Bool = false
    var renderRetrogradesWithInvertedColors:Bool = false
    var solidColors:Bool = false
    var markYears:Bool = true
    var markMonths:Bool = true
    var largeMarks:Bool = true
    
    var pixelsLeftForLargeMark:Int = 0
    func generateStrip(planet: Astrology.AspectBody, platnetStateTimeline:[PlanetState]) -> PsionoStreamImageStrip? {
        
        let width = platnetStateTimeline.count
        let height = 1
        
        var rgbaArray:[RGBAColor] = platnetStateTimeline.map { (planetState) -> RGBAColor in
            
            if largeMarks {
                if markMonths && planetState.monthDidChange {
                    pixelsLeftForLargeMark = 4
                }
                if markYears && planetState.yearDidChange {
                    pixelsLeftForLargeMark = 8
                }
                if markYears && pixelsLeftForLargeMark > 0 {
                    pixelsLeftForLargeMark -= 1
                    return RGBAColor.black
                }
                if markMonths && pixelsLeftForLargeMark > 0 {
                    pixelsLeftForLargeMark -= 1
                    return RGBAColor.black
                }
            } else {
                if markYears && planetState.yearDidChange {
                    return RGBAColor.black
                }
                if markMonths && planetState.monthDidChange {
                    return RGBAColor.black
                }
            }
            
            guard renderAtAll else {
                return RGBAColor.clear
            }
            
            if renderRetrogrades {
                if renderRetrogradesWithInvertedColors {
                    return RGBAColor(degrees: planetState.degrees, invert: planetState.retrogradeState == .retrograde, solidColors: solidColors)
                } else {
                    switch planetState.retrogradeState {
                    case .retrograde: return RGBAColor.black
                    case .direct: return RGBAColor.white
                    }
                }
            } else {
                return RGBAColor(degrees: planetState.degrees, invert: false, solidColors: solidColors)
            }
        }

        let bitmapCount: Int = rgbaArray.count
        let elmentLength: Int = 4 // Bytes
        let render: CGColorRenderingIntent = .defaultIntent//CGColorRenderingIntent.RenderingIntentDefault
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        guard let providerRef: CGDataProvider = CGDataProvider(data: NSData(bytes: &rgbaArray, length: bitmapCount * elmentLength)) else {
            print("ERROR: CGDataProvider could not be generated")
            return nil
        }
        
        guard let cgImage: CGImage = CGImage(width: width, height: height, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: width * elmentLength, space: rgbColorSpace, bitmapInfo: bitmapInfo, provider: providerRef, decode: nil, shouldInterpolate: true, intent: render) else {
            print("ERROR: CGImage could not be generated")
            return nil
        }
        
        return PsionoStreamImageStrip(cgImage: cgImage,
                            planet: planet,
                            retrograde: renderRetrogrades,
                            retrogradeInverted: renderRetrogradesWithInvertedColors,
                            solidColors: solidColors,
                            width: width)
    }
    
    struct PlanetState {
        let date:Date?
        let degrees:Float
        let retrogradeState:RetrogradeState
        let speed:Float
        let monthDidChange:Bool
        let yearDidChange:Bool
    }
    
    enum RetrogradeState {
        case direct
        case retrograde
    }
}

//extension NSImage {
//    var pngData: Data? {
//        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
//        return bitmapImage.representation(using: .png, properties: [:])
//    }
//    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
//        do {
//            try pngData?.write(to: url, options: options)
//            return true
//        } catch {
//            print(error)
//            return false
//        }
//    }
//}

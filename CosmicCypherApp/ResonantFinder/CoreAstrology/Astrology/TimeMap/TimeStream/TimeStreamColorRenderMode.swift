//
//  TimeStreamColorRenderMode.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/15/22.
//

import Foundation

extension TimeStream {
    
    // Data Metric Option
    public typealias DataMetricList = [DataMetric]
    public enum DataMetric: String, CaseIterable {
        case harmonics
        case retrogrades
        case gravimetrics
        case distance
        
        var title:String {
            switch self {
            case .harmonics: return "Harmonics"
            case .retrogrades: return "Retrogrades"
            case .gravimetrics: return "Gravimetrics"
            case .distance: return "Distance"
            }
        }
        
        var filenameText: String {
            return self.rawValue
        }
        
        func has(title:String) -> Bool {
            return self.title == title
        }
        
        static func from(title:String) -> DataMetric? {
            for dataMetric in DataMetric.allCases {
                if dataMetric.title == title { return dataMetric }
            }
            return nil
        }
    }
    
    // Color Render Mode
    public typealias ColorRenderModeList = [ColorRenderMode]
    public enum ColorRenderMode: Int, CaseIterable {
        
        // Color Render Modes
        case colorGradient
        case solidColors
        case blackWhite
        case greyscale
        case alphascale
        case clear
        
        
        
        var title:String {
            switch self {
            case .colorGradient: return "Gradient RGYB Color (default)"
            case .solidColors: return "Solid RGYB Color"
            case .blackWhite: return "Black & White"
            case .greyscale: return "Grayscale"
            case .alphascale: return "Alphascale"
            case .clear: return "Clear"
            }
        }
        
        var shortTitle:String {
            switch self {
            case .colorGradient: return "Gradient Color"
            case .solidColors: return "Solid Color"
            case .blackWhite: return "Black & White"
            case .greyscale: return "Grayscale"
            case .alphascale: return "Alphascale"
            case .clear: return "Clear"
            }
        }
        
        var filenameText: String {
            switch self {
            case .colorGradient: return "colorGradient"
            case .solidColors: return "solidColors"
            case .blackWhite: return "blackWhite"
            case .greyscale: return "grayscale"
            case .alphascale: return "alphascale"
            case .clear: return "clear"
            }
        }
        
        func has(title:String) -> Bool {
            return self.title == title
        }
        
        static func from(title:String) -> ColorRenderMode? {
            for renderMode in ColorRenderMode.allCases {
                if renderMode.title == title { return renderMode }
            }
            return nil
        }
        
        func renderColor(dataMetric: DataMetric, planetNodeState: PlanetNodeState) -> RGBAColor {
            let invert = dataMetric == .retrogrades && planetNodeState.motionState?.currentMotion == .retrograde(.none)
            switch self {
            case .clear:
                return RGBAColor.clear
            case .colorGradient:
                return RGBAColor(degrees: Float(planetNodeState.degrees.value), invert: invert, solidColors: false)
            case .solidColors:
                return RGBAColor(degrees: Float(planetNodeState.degrees.value), invert: invert, solidColors: true)
            case .blackWhite:
                return invert ? RGBAColor.black : RGBAColor.white
            case .greyscale:
                switch dataMetric {
                case .retrogrades: return RGBAColor.greyscale(brightness: 0)
                case .harmonics: return RGBAColor.greyscale(brightness: 0)
                case .distance: return RGBAColor.greyscale(brightness: 0)
                case .gravimetrics: return RGBAColor.greyscale(brightness: 0)
                }
            case .alphascale:
                switch dataMetric {
                case .retrogrades: return RGBAColor.alphascale(opacity: 0)
                case .harmonics: return RGBAColor.alphascale(opacity: 0)
                case .distance: return RGBAColor.alphascale(opacity: 0)
                case .gravimetrics: return RGBAColor.alphascale(opacity: 0)
                }
            }
        }
    }
}

//
//  Decan.swift
//  PsiKit
//
//  Created by Jordan Trana on 11/28/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import Foundation
import SwiftAA

extension Arcana {
    
    /// 36 Decans - Egyptian Conversion
    public enum Decan: Int, CaseIterable, Codable {
        
        public static let count:Int = 36
        public static func from(degree: Degree) -> Decan {
            let totalDegrees = 360
            let degreeValue = degree.value
            let decanAccurate = (Double(degreeValue) / Double(totalDegrees)) * Double(count)
            var decanIndex = Int(decanAccurate.truncatingRemainder(dividingBy: Double(count)))
            if decanIndex < 0 { decanIndex += count }
            return Decan(rawValue: decanIndex)!
        }

        public static func subFrom(degree: Degree) -> Decan {
            let totalDegrees = 360
            let degreeValue = degree.value
            let decanAccurate = (Double(degreeValue) / Double(totalDegrees)) * Double(count)
            var decanIndex = Int(decanAccurate.truncatingRemainder(dividingBy: Double(count)))
            if decanIndex < 0 { decanIndex += count }
            
            let isUpperHalf = decanAccurate.truncatingRemainder(dividingBy: 1) > 0.5
            if isUpperHalf {
                decanIndex = (decanIndex + 1) % count
            } else {
                decanIndex = (decanIndex - 1 + count) % count
            }
            
            return Decan(rawValue: decanIndex)!
        }
        
        /// Aries
        case child // 1
        case star // 2
        case pioneer // 3
        
        /// Taurus
        case manifestation
        case teacher
        case natural
        
        /// Gemini
        case freedom
        case newLanguage
        case seeker
        
        /// Cancer
        case empath
        case unconventional
        case pursuader
        
        /// Leo
        case authority
        case balancedStrength
        case leadership
        
        /// Virgo
        case systemBuilders
        case enigma
        case literalist
        
        /// Libra
        case perfection
        case society
        case thearter
        
        /// Scorpio
        case intensity
        case depth
        case charm
        
        ///Sagittarius
        case independent
        case originator
        case titan
        
        /// Capricorn
        case ruler
        case determination
        case dominance
        
        /// Aquarius
        case genius
        case youthAndEase
        case acceptance
        
        /// Pisces
        case spirit
        case loner
        case dancersAndDreamers
        
        public var degrees:Double {
            return Double(self.rawValue) * (360/Double(Decan.count))
        }
        
        public var zodiac:Zodiac {
            switch self {
            case .child, .star, .pioneer: return .aries
            case .manifestation, .teacher, .natural: return .taurus
            case .freedom, .newLanguage, .seeker: return .gemini
            case .empath, .unconventional, .pursuader: return .cancer
            case .authority, .balancedStrength, .leadership: return .leo
            case .systemBuilders, .enigma, .literalist: return .virgo
            case .perfection, .society, .thearter: return .libra
            case .intensity, .depth, .charm: return .scorpio
            case .independent, .originator, .titan: return .sagittarius
            case .ruler, .determination, .dominance: return .capricorn
            case .genius, .youthAndEase, .acceptance: return .aquarius
            case .spirit, .loner, .dancersAndDreamers: return .pisces
            }
        }
        
        enum DecanElement {
            case fire(_ modality:FireModality)
            enum FireModality {
                case active(_ decan:FireDecan)
                case passive(_ decan:FireDecan)
                case fixed(_ decan:FireDecan)
                enum FireDecan {
                    case chaos
                    case prime
                    case core
                }
            }
            case earth(_ modality:EarthModality)
            enum EarthModality {
                case active(_ decan:EarthDecan)
                case passive(_ decan:EarthDecan)
                case fixed(_ decan:EarthDecan)
                enum EarthDecan {
                    case core
                    case prime
                    case order
                }
            }
            case air(_ modality:AirModality)
            enum AirModality {
                case active(_ decan:AirDecan)
                case passive(_ decan:AirDecan)
                case fixed(_ decan:AirDecan)
                enum AirDecan {
                    case order
                    case prime
                    case void
                }
            }
            case water(_ modality:WaterModality)
            enum WaterModality {
                case active(_ decan:WaterDecan)
                case passive(_ decan:WaterDecan)
                case fixed(_ decan:WaterDecan)
                enum WaterDecan {
                    case void
                    case prime
                    case chaos
                }
            }
        }
    }
    
}

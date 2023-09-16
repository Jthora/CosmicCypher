//
//  Zodiac.swift
//  PsiKit
//
//  Created by Jordan Trana on 11/28/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import Foundation
import SwiftAA

extension Arcana {
    /// 12 Zodiac Signs - Greek
    public enum Zodiac:Int, CaseIterable {
        
        case aries
        case taurus
        case gemini
        case cancer
        case leo
        case virgo
        case libra
        case scorpio
        case sagittarius
        case capricorn
        case aquarius
        case pisces

        public static let count:Double = 12
        
        public static func from(degree:Degree) -> Zodiac {
            var zodiacAccurate = (((degree.value)/360)*count).truncatingRemainder(dividingBy: count)
            if zodiacAccurate < 0 { zodiacAccurate += count }
            let zodiac = Zodiac(rawValue: Int(zodiacAccurate))!
            print("creating Zodiac(\(zodiac)) degree(\(degree))")
            return zodiac
        }
        
        public static func subFrom(degree: Degree) -> Zodiac {
            var zodiacAccurate = (((degree.value)/360)*count).truncatingRemainder(dividingBy: count)
            if zodiacAccurate < 0 { zodiacAccurate += count }
            if zodiacAccurate.truncatingRemainder(dividingBy: 1) > 0.5 {
                var index = abs(Int(zodiacAccurate)+1)
                if index > Int(count)-1 { index = 0 }
                return Zodiac(rawValue: index)!
            } else {
                var index = Int(zodiacAccurate)-1
                if index < 0 { index = Int(count)-1 }
                return Zodiac(rawValue: index)!
            }
        }
        
        public static func from(_ decan:Decan) -> Zodiac {
            switch decan {
                case .child, .star, .pioneer: return aries
                case .manifestation, .teacher, .natural: return taurus
                case .freedom, .newLanguage, .seeker: return gemini
                case .empath, .unconventional, .pursuader: return cancer
                case .authority, .balancedStrength, .leadership: return leo
                case .systemBuilders, .enigma, .literalist: return virgo
                case .perfection, .society, .thearter: return libra
                case .intensity, .depth, .charm: return scorpio
                case .independent, .originator, .titan: return sagittarius
                case .ruler, .determination, .dominance: return capricorn
                case .genius, .youthAndEase, .acceptance: return aquarius
                case .spirit, .loner, .dancersAndDreamers: return pisces
            }
        }
        
        public var element:Element {
            switch self {
                case .aries, .leo, .sagittarius: return .fire
                case .taurus, .virgo, .capricorn: return .earth
                case .gemini, .libra, .aquarius: return .air
                case .cancer, .scorpio, .pisces: return .water
            }
        }
        
        public var modality:Modality {
            switch self {
                case .aries, .cancer, .libra, .capricorn: return .cardinal
                case .taurus, .leo, .scorpio, .aquarius: return .fixed
                case .gemini, .virgo, .sagittarius, .pisces: return .mutable
            }
        }
        
        public var imageName:String {
            switch self {
            case .aries: return "AstrologyIcon_Arkana_Aries"
            case .taurus: return "AstrologyIcon_Arkana_Taurus"
            case .gemini: return "AstrologyIcon_Arkana_Gemini"
            case .cancer: return "AstrologyIcon_Arkana_Cancer"
            case .leo: return "AstrologyIcon_Arkana_Leo"
            case .virgo: return "AstrologyIcon_Arkana_Virgo"
            case .libra: return "AstrologyIcon_Arkana_Libra"
            case .scorpio: return "AstrologyIcon_Arkana_Scorpio"
            case .sagittarius: return "AstrologyIcon_Arkana_Sagittarius"
            case .capricorn: return "AstrologyIcon_Arkana_Capricorn"
            case .aquarius: return "AstrologyIcon_Arkana_Aquarius"
            case .pisces: return "AstrologyIcon_Arkana_Pisces"
            }
        }
        
        public var imageNameWhite:String {
            return imageName + "_White"
        }
        
        public var image:StarKitImage {
            switch self {
            case .aries: return StarKitAssets.Images.ZodiacSymbols.aries
            case .taurus: return StarKitAssets.Images.ZodiacSymbols.taurus
            case .gemini: return StarKitAssets.Images.ZodiacSymbols.gemini
            case .cancer: return StarKitAssets.Images.ZodiacSymbols.cancer
            case .leo: return StarKitAssets.Images.ZodiacSymbols.leo
            case .virgo: return StarKitAssets.Images.ZodiacSymbols.virgo
            case .libra: return StarKitAssets.Images.ZodiacSymbols.libra
            case .scorpio: return StarKitAssets.Images.ZodiacSymbols.scorpio
            case .sagittarius: return StarKitAssets.Images.ZodiacSymbols.sagittarius
            case .capricorn: return StarKitAssets.Images.ZodiacSymbols.capricorn
            case .aquarius: return StarKitAssets.Images.ZodiacSymbols.aquarius
            case .pisces: return StarKitAssets.Images.ZodiacSymbols.pisces
            }
        }
        
        
        
        
        public var duality:Duality {
            return self.element.duality
        }
        
    }
    
}

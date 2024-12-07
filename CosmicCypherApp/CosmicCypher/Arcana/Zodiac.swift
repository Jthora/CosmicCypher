//
//  Zodiac.swift
//  PsiKit
//
//  Created by Jordan Trana on 11/28/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import UIKit
import SwiftAA


extension Arcana {

    
    /// 12 Zodiac Signs - Greek
    enum Zodiac:Int, CaseIterable {
        
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

        static let count:Double = 12
        
        static func from(degree:Degree) -> Zodiac {
            var zodiacAccurate = (((degree.value)/360)*count).truncatingRemainder(dividingBy: count)
            if zodiacAccurate < 0 { zodiacAccurate += count }
            return Zodiac(rawValue: Int(zodiacAccurate))!
        }
        
        static func subFrom(degree: Degree) -> Zodiac {
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
        
        static func from(_ decan:Decan) -> Zodiac {
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
        
        var element:Element {
            switch self {
                case .aries, .leo, .sagittarius: return .fire
                case .taurus, .virgo, .capricorn: return .earth
                case .gemini, .libra, .aquarius: return .air
                case .cancer, .scorpio, .pisces: return .water
            }
        }
        
        var modality:Modality {
            switch self {
                case .aries, .cancer, .libra, .capricorn: return .cardinal
                case .taurus, .leo, .scorpio, .aquarius: return .fixed
                case .gemini, .virgo, .sagittarius, .pisces: return .mutable
            }
        }
        
        var imageName:String {
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
        
        var imageNameWhite:String {
            return imageName + "_White"
        }
        
        var image:UIImage {
            switch self {
            case .aries: return Assets.Images.ZodiacSymbols.aries
            case .taurus: return Assets.Images.ZodiacSymbols.taurus
            case .gemini: return Assets.Images.ZodiacSymbols.gemini
            case .cancer: return Assets.Images.ZodiacSymbols.cancer
            case .leo: return Assets.Images.ZodiacSymbols.leo
            case .virgo: return Assets.Images.ZodiacSymbols.virgo
            case .libra: return Assets.Images.ZodiacSymbols.libra
            case .scorpio: return Assets.Images.ZodiacSymbols.scorpio
            case .sagittarius: return Assets.Images.ZodiacSymbols.sagittarius
            case .capricorn: return Assets.Images.ZodiacSymbols.capricorn
            case .aquarius: return Assets.Images.ZodiacSymbols.aquarius
            case .pisces: return Assets.Images.ZodiacSymbols.pisces
            }
        }
        
        
        struct Level {
            var power:Double = 0
            var unlock:Double = 0
            var distribution:Double = 0
            var subDistribution:Double = 0
        }

        class Index {
            
            var count:Double = 0
            var powerCount:Double = 0
            
            var aries:Level = Level()
            var taurus:Level = Level()
            var gemini:Level = Level()
            var cancer:Level = Level()
            var leo:Level = Level()
            var virgo:Level = Level()
            var libra:Level = Level()
            var scorpio:Level = Level()
            var sagittarius:Level = Level()
            var capricorn:Level = Level()
            var aquarius:Level = Level()
            var pisces:Level = Level()
            
            var totalPower:Double {
                var total:Double = 0
                for zodiac in Arcana.Zodiac.allCases {
                    total += self.power(for: zodiac)
                }
                return total
            }
            
            var totalUnlock:Double {
                var total:Double = 0
                for zodiac in Arcana.Zodiac.allCases {
                    total += self.unlock(for: zodiac)
                }
                return total
            }
            
            var total:Double {
                return totalPower + totalUnlock
            }
            
            var average:Double {
                return total / Double(Arcana.Zodiac.allCases.count)
            }
            
            var cardinalEnergy:Double {
                return (aries.distribution + aries.subDistribution + cancer.distribution + cancer.subDistribution + libra.distribution + libra.subDistribution + capricorn.distribution + capricorn.subDistribution)/count
            }
            
            var fixedEnergy:Double {
                return (taurus.distribution + taurus.subDistribution + leo.distribution + leo.subDistribution + scorpio.distribution + scorpio.subDistribution + aquarius.distribution + aquarius.subDistribution)/count
            }
            
            var mutableEnergy:Double {
                return (gemini.distribution + gemini.subDistribution + virgo.distribution + virgo.subDistribution + sagittarius.distribution + sagittarius.subDistribution + pisces.distribution + pisces.subDistribution)/count
            }
            
            init(alignments: [Astrology.AspectBody:StarChartAlignment], limitList:[Astrology.AspectBody]? = nil , limitType:[AstrologicalNodeType]? = nil) {
                
                
                for (_,alignment) in alignments {
                    
                    if let limitList = limitList {
                        guard limitList.contains(alignment.aspectBody) else { continue }
                    }
                    
                    if let limitType = limitType {
                        guard limitType.contains(alignment.type) else { continue }
                    }
                    
                    let chevron = alignment.createChevron()
                    if let powerLevel = chevron.powerLevel,
                    let unlockLevel = chevron.unlockLevel {
                            // Natura
                            add(power: powerLevel * chevron.zodiacDistribution, to: chevron.zodiac)
                            add(unlock: unlockLevel * chevron.zodiacDistribution, to: chevron.zodiac)
                            // SubNatura
                            add(power: powerLevel * chevron.subZodiacDistribution, to: chevron.subZodiac)
                            add(unlock: unlockLevel * chevron.subZodiacDistribution, to: chevron.subZodiac)
                        
                            powerCount += 1
                        }
                    // Distribution
                    add(distribution: chevron.zodiacDistribution, to: chevron.zodiac)
                    add(subDistribution: chevron.subZodiacDistribution, to: chevron.subZodiac)
                    
                    count += 1
                }
            }
            
            func add(power:Double, to zodiac:Arcana.Zodiac) {
                switch zodiac {
                case .aries: aries.power += power
                case .taurus: taurus.power += power
                case .gemini: gemini.power += power
                case .cancer: cancer.power += power
                case .leo: leo.power += power
                case .virgo: virgo.power += power
                case .libra: libra.power += power
                case .scorpio: scorpio.power += power
                case .sagittarius: sagittarius.power += power
                case .capricorn: capricorn.power += power
                case .aquarius: aquarius.power += power
                case .pisces: pisces.power += power
                }
            }
            
            func add(unlock:Double, to zodiac:Arcana.Zodiac) {
                switch zodiac {
                case .aries: aries.unlock += unlock
                case .taurus: taurus.unlock += unlock
                case .gemini: gemini.unlock += unlock
                case .cancer: cancer.unlock += unlock
                case .leo: leo.unlock += unlock
                case .virgo: virgo.unlock += unlock
                case .libra: libra.unlock += unlock
                case .scorpio: scorpio.unlock += unlock
                case .sagittarius: sagittarius.unlock += unlock
                case .capricorn: capricorn.unlock += unlock
                case .aquarius: aquarius.unlock += unlock
                case .pisces: pisces.unlock += unlock
                }
            }
            
            func add(distribution:Double, to zodiac:Arcana.Zodiac) {
                switch zodiac {
                case .aries: aries.distribution += distribution
                case .taurus: taurus.distribution += distribution
                case .gemini: gemini.distribution += distribution
                case .cancer: cancer.distribution += distribution
                case .leo: leo.distribution += distribution
                case .virgo: virgo.distribution += distribution
                case .libra: libra.distribution += distribution
                case .scorpio: scorpio.distribution += distribution
                case .sagittarius: sagittarius.distribution += distribution
                case .capricorn: capricorn.distribution += distribution
                case .aquarius: aquarius.distribution += distribution
                case .pisces: pisces.distribution += distribution
                }
            }
            
            func add(subDistribution:Double, to zodiac:Arcana.Zodiac) {
                switch zodiac {
                case .aries: aries.subDistribution += subDistribution
                case .taurus: taurus.subDistribution += subDistribution
                case .gemini: gemini.subDistribution += subDistribution
                case .cancer: cancer.subDistribution += subDistribution
                case .leo: leo.subDistribution += subDistribution
                case .virgo: virgo.subDistribution += subDistribution
                case .libra: libra.subDistribution += subDistribution
                case .scorpio: scorpio.subDistribution += subDistribution
                case .sagittarius: sagittarius.subDistribution += subDistribution
                case .capricorn: capricorn.subDistribution += subDistribution
                case .aquarius: aquarius.subDistribution += subDistribution
                case .pisces: pisces.subDistribution += subDistribution
                }
            }
            
            func power(for zodiac:Arcana.Zodiac, normalized:Bool = false) -> Double {
                switch zodiac {
                case .aries: return normalized ? aries.power/total : aries.power
                case .taurus: return normalized ? taurus.power/total : taurus.power
                case .gemini: return normalized ? gemini.power/total : gemini.power
                case .cancer: return normalized ? cancer.power/total : cancer.power
                case .leo: return normalized ? leo.power/total : leo.power
                case .virgo: return normalized ? virgo.power/total : virgo.power
                case .libra: return normalized ? libra.power/total : libra.power
                case .scorpio: return normalized ? scorpio.power/total : scorpio.power
                case .sagittarius: return normalized ? sagittarius.power/total : sagittarius.power
                case .capricorn: return normalized ? capricorn.power/total : capricorn.power
                case .aquarius: return normalized ? aquarius.power/total : aquarius.power
                case .pisces: return normalized ? pisces.power/total : pisces.power
                }
            }
            
            func unlock(for zodiac:Arcana.Zodiac, normalized:Bool = false) -> Double {
                switch zodiac {
                case .aries: return normalized ? aries.unlock/total : aries.unlock
                case .taurus: return normalized ? taurus.unlock/total : taurus.unlock
                case .gemini: return normalized ? gemini.unlock/total : gemini.unlock
                case .cancer: return normalized ? cancer.unlock/total : cancer.unlock
                case .leo: return normalized ? leo.unlock/total : leo.unlock
                case .virgo: return normalized ? virgo.unlock/total : virgo.unlock
                case .libra: return normalized ? libra.unlock/total : libra.unlock
                case .scorpio: return normalized ? scorpio.unlock/total : scorpio.unlock
                case .sagittarius: return normalized ? sagittarius.unlock/total : sagittarius.unlock
                case .capricorn: return normalized ? capricorn.unlock/total : capricorn.unlock
                case .aquarius: return normalized ? aquarius.unlock/total : aquarius.unlock
                case .pisces: return normalized ? pisces.unlock/total : pisces.unlock
                }
            }
            
            func totalDistribution(for zodiac:Arcana.Zodiac, normalized:Bool = false) -> Double {
                let sub = subDistribution(for: zodiac, normalized: normalized)
                let dist = distribution(for: zodiac, normalized: normalized)
                let total = sub + dist
                return total
            }
            
            func distribution(for zodiac:Arcana.Zodiac, normalized:Bool = false) -> Double {
                switch zodiac {
                case .aries: return normalized ? aries.distribution/total : aries.distribution
                case .taurus: return normalized ? taurus.distribution/total : taurus.distribution
                case .gemini: return normalized ? gemini.distribution/total : gemini.distribution
                case .cancer: return normalized ? cancer.distribution/total : cancer.distribution
                case .leo: return normalized ? leo.distribution/total : leo.distribution
                case .virgo: return normalized ? virgo.distribution/total : virgo.distribution
                case .libra: return normalized ? libra.distribution/total : libra.distribution
                case .scorpio: return normalized ? scorpio.distribution/total : scorpio.distribution
                case .sagittarius: return normalized ? sagittarius.distribution/total : sagittarius.distribution
                case .capricorn: return normalized ? capricorn.distribution/total : capricorn.distribution
                case .aquarius: return normalized ? aquarius.distribution/total : aquarius.distribution
                case .pisces: return normalized ? pisces.distribution/total : pisces.distribution
                }
            }
            
            func subDistribution(for zodiac:Arcana.Zodiac, normalized:Bool = false) -> Double {
                switch zodiac {
                case .aries: return normalized ? aries.subDistribution/total : aries.subDistribution
                case .taurus: return normalized ? taurus.subDistribution/total : taurus.subDistribution
                case .gemini: return normalized ? gemini.subDistribution/total : gemini.subDistribution
                case .cancer: return normalized ? cancer.subDistribution/total : cancer.subDistribution
                case .leo: return normalized ? leo.subDistribution/total : leo.subDistribution
                case .virgo: return normalized ? virgo.subDistribution/total : virgo.subDistribution
                case .libra: return normalized ? libra.subDistribution/total : libra.subDistribution
                case .scorpio: return normalized ? scorpio.subDistribution/total : scorpio.subDistribution
                case .sagittarius: return normalized ? sagittarius.subDistribution/total : sagittarius.subDistribution
                case .capricorn: return normalized ? capricorn.subDistribution/total : capricorn.subDistribution
                case .aquarius: return normalized ? aquarius.subDistribution/total : aquarius.subDistribution
                case .pisces: return normalized ? pisces.subDistribution/total : pisces.subDistribution
                }
            }
        }
        
        
        var duality:Duality {
            return self.element.duality
        }
        
    }
    
}

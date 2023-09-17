//
//  Zodiac+Index.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/14/23.
//

import Foundation


extension Arcana.Zodiac {
    
    public struct Level {
        var power:Double = 0
        var unlock:Double = 0
        var distribution:Double = 0
        var subDistribution:Double = 0
    }
    
    public class Index {
        
        public var count:Double = 0
        public var powerCount:Double = 0
        
        // Zodiac Levels
        public var aries:Level = Level()
        public var taurus:Level = Level()
        public var gemini:Level = Level()
        public var cancer:Level = Level()
        public var leo:Level = Level()
        public var virgo:Level = Level()
        public var libra:Level = Level()
        public var scorpio:Level = Level()
        public var sagittarius:Level = Level()
        public var capricorn:Level = Level()
        public var aquarius:Level = Level()
        public var pisces:Level = Level()
        
        public var totalPower:Double {
            var total:Double = 0
            for zodiac in Arcana.Zodiac.allCases {
                total += self.power(for: zodiac)
            }
            return total
        }
        
        public var totalUnlock:Double {
            var total:Double = 0
            for zodiac in Arcana.Zodiac.allCases {
                total += self.unlock(for: zodiac)
            }
            return total
        }
        
        public var total:Double {
            return totalPower + totalUnlock
        }
        
        public var average:Double {
            return total / Double(Arcana.Zodiac.allCases.count)
        }
        
        public var cardinalEnergy:Double {
            return (aries.distribution + aries.subDistribution + cancer.distribution + cancer.subDistribution + libra.distribution + libra.subDistribution + capricorn.distribution + capricorn.subDistribution)/count
        }
        
        public var fixedEnergy:Double {
            return (taurus.distribution + taurus.subDistribution + leo.distribution + leo.subDistribution + scorpio.distribution + scorpio.subDistribution + aquarius.distribution + aquarius.subDistribution)/count
        }
        
        public var mutableEnergy:Double {
            return (gemini.distribution + gemini.subDistribution + virgo.distribution + virgo.subDistribution + sagittarius.distribution + sagittarius.subDistribution + pisces.distribution + pisces.subDistribution)/count
        }
        
        public init(alignments: [CoreAstrology.AspectBody.NodeType:AstrologicalNode], limitList:[CoreAstrology.AspectBody.NodeType]? = nil , limitType:[AstrologicalNodeSubType]? = nil) {
            
            
            for (_,alignment) in alignments {
                
                if let limitList = limitList {
                    guard limitList.contains(alignment.nodeType) else { continue }
                }
                
                if let limitType = limitType {
                    guard limitType.contains(alignment.subType) else { continue }
                }
                
                let chevron = alignment.createChevron()
                // Distribution
                add(distribution: chevron.zodiacDistribution, to: chevron.zodiac)
                add(subDistribution: chevron.subZodiacDistribution, to: chevron.subZodiac)
                
                count += 1
            }
        }
        
        public func add(power:Double, to zodiac:Arcana.Zodiac) {
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
        
        public func add(unlock:Double, to zodiac:Arcana.Zodiac) {
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
        
        public func add(distribution:Double, to zodiac:Arcana.Zodiac) {
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
        
        public func add(subDistribution:Double, to zodiac:Arcana.Zodiac) {
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
        
        public func power(for zodiac:Arcana.Zodiac, normalized:Bool = false) -> Double {
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
        
        public func unlock(for zodiac:Arcana.Zodiac, normalized:Bool = false) -> Double {
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
        
        public func totalDistribution(for zodiac:Arcana.Zodiac, normalized:Bool = false) -> Double {
            let sub = subDistribution(for: zodiac, normalized: normalized)
            let dist = distribution(for: zodiac, normalized: normalized)
            let total = sub + dist
            return total
        }
        
        public func distribution(for zodiac:Arcana.Zodiac, normalized:Bool = false) -> Double {
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
        
        public func subDistribution(for zodiac:Arcana.Zodiac, normalized:Bool = false) -> Double {
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
}

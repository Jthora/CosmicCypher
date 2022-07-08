//
//  Natura.swift
//  PsiKit
//
//  Created by Jordan Trana on 11/28/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//


import SwiftAA

extension Arcana {
    
    public enum Natura:Int, CaseIterable {
        
        case nether
        case fire
        case core
        case earth
        case aether
        case air
        case void
        case water
        
        public static let superCount:Double = 24
        public static let count:Double = 8
        
        public static func from(degree:Degree) -> Natura {
            var naturaAccurate = ((((degree.value+7.5)/360)*superCount)).truncatingRemainder(dividingBy: count)
            if naturaAccurate < 0 { naturaAccurate += count }
            return Natura(rawValue: Int(naturaAccurate))!
        }
        
        public static func subFrom(degree: Degree) -> Natura {
            var naturaAccurate = (((degree.value+7.5)/360)*superCount).truncatingRemainder(dividingBy: count)
            if naturaAccurate < 0 { naturaAccurate += count }
            if naturaAccurate.truncatingRemainder(dividingBy: 1) > 0.5 {
                var index = abs(Int(naturaAccurate)+1)
                if index > Int(count)-1 { index = 0 }
                return Natura(rawValue: index)!
            } else {
                var index = Int(naturaAccurate)-1
                if index < 0 { index = Int(count)-1 }
                return Natura(rawValue: index)!
            }
        }
        
        public static func from(_ element:Element) -> Natura {
            switch element {
                case .air: return .air
                case .water: return .water
                case .earth: return .earth
                case .fire: return .fire
            }
        }
        
        public static func from(_ force:Force) -> Natura {
            switch force {
                case .light: return .aether
                case .heat: return .nether
                case .gravity: return .void
                case .magnetism: return .core
            }
        }
        
        public var force:Force? {
            switch self {
                case .aether: return .light
                case .nether: return .heat
                case .core: return .magnetism
                case .void: return .gravity
                default: return nil
            }
        }
        
        public var element:Element? {
            switch self {
                case .air: return .air
                case .fire: return .fire
                case .water: return .water
                case .earth: return .earth
                default: return nil
            }
        }
        
        public var duality:Duality? {
            return force?.duality ?? element?.duality
        }
        
        public var image:StarKitImage {
            switch self {
            case .fire: return StarKitAssets.Images.NaturaSymbols.fire
            case .air: return StarKitAssets.Images.NaturaSymbols.air
            case .water: return StarKitAssets.Images.NaturaSymbols.water
            case .earth: return StarKitAssets.Images.NaturaSymbols.earth
            case .aether: return StarKitAssets.Images.NaturaSymbols.one
            case .nether: return StarKitAssets.Images.NaturaSymbols.many
            case .core: return StarKitAssets.Images.NaturaSymbols.core
            case .void: return StarKitAssets.Images.NaturaSymbols.void
            }
        }
        
        public struct Level {
            public var power:Double = 0
            public var unlock:Double = 0
            public var distribution:Double = 0
            public var subDistribution:Double = 0
        }
        
        open class Index {
            
            public var count:Double = 0
            public var powerCount:Double = 0
            
            public var nether:Level = Level()
            public var water:Level = Level()
            public var void:Level = Level()
            public var air:Level = Level()
            public var aether:Level = Level()
            public var earth:Level = Level()
            public var core:Level = Level()
            public var fire:Level = Level()
            
            public var averagePower:Double {
                return totalPower / powerCount
            }
            public var totalPower:Double {
                var total:Double = 0
                for natura in Arcana.Natura.allCases {
                    total += self.power(for: natura)
                }
                return total
            }
            
            public var averageUnlock:Double {
                return totalUnlock / powerCount
            }
            public var totalUnlock:Double {
                var total:Double = 0
                for natura in Arcana.Natura.allCases {
                    total += self.unlock(for: natura)
                }
                return total
            }
            
            public var highestPowerLevel:Double = 0
            public var highestUnlockLevel:Double = 0
            
            
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
                    add(distribution: chevron.naturaDistribution, to: chevron.natura)
                    add(subDistribution: chevron.subNaturaDistribution, to: chevron.subNatura)
                    
                    count += 1
                }
            }
            
            public func add(power:Double, to natura:Arcana.Natura) {
                switch natura {
                case .nether: nether.power += power
                case .water: water.power += power
                case .void: void.power += power
                case .air: air.power += power
                case .aether: aether.power += power
                case .earth: earth.power += power
                case .core: core.power += power
                case .fire: fire.power += power
                }
            }
            
            public func add(unlock:Double, to natura:Arcana.Natura) {
                switch natura {
                case .nether: nether.unlock += unlock
                case .water: water.unlock += unlock
                case .void: void.unlock += unlock
                case .air: air.unlock += unlock
                case .aether: aether.unlock += unlock
                case .earth: earth.unlock += unlock
                case .core: core.unlock += unlock
                case .fire: fire.unlock += unlock
                }
            }
            
            public func add(distribution:Double, to natura:Arcana.Natura) {
                switch natura {
                case .nether: nether.distribution += distribution
                case .water: water.distribution += distribution
                case .void: void.distribution += distribution
                case .air: air.distribution += distribution
                case .aether: aether.distribution += distribution
                case .earth: earth.distribution += distribution
                case .core: core.distribution += distribution
                case .fire: fire.distribution += distribution
                }
            }
            
            public func add(subDistribution:Double, to natura:Arcana.Natura) {
                switch natura {
                case .nether: nether.subDistribution += subDistribution
                case .water: water.subDistribution += subDistribution
                case .void: void.subDistribution += subDistribution
                case .air: air.subDistribution += subDistribution
                case .aether: aether.subDistribution += subDistribution
                case .earth: earth.subDistribution += subDistribution
                case .core: core.subDistribution += subDistribution
                case .fire: fire.subDistribution += subDistribution
                }
            }
            
            public func power(for natura:Arcana.Natura, normalized:Bool = false) -> Double {
                switch natura {
                case .nether: return normalized ? nether.power/powerCount : nether.power
                case .water: return normalized ? water.power/powerCount : water.power
                case .void: return normalized ? void.power/powerCount : void.power
                case .air: return normalized ? air.power/powerCount : air.power
                case .aether: return normalized ? aether.power/powerCount : aether.power
                case .earth: return normalized ? earth.power/powerCount : earth.power
                case .core: return normalized ? core.power/powerCount : core.power
                case .fire: return normalized ? fire.power/powerCount : fire.power
                }
            }
            
            public func unlock(for natura:Arcana.Natura, normalized:Bool = false) -> Double {
                switch natura {
                case .nether: return normalized ? nether.unlock/powerCount : nether.unlock
                case .water: return normalized ? water.unlock/powerCount : water.unlock
                case .void: return normalized ? void.unlock/powerCount : void.unlock
                case .air: return normalized ? air.unlock/powerCount : air.unlock
                case .aether: return normalized ? aether.unlock/powerCount : aether.unlock
                case .earth: return normalized ? earth.unlock/powerCount : earth.unlock
                case .core: return normalized ? core.unlock/powerCount : core.unlock
                case .fire: return normalized ? fire.unlock/powerCount : fire.unlock
                }
            }
            
            public func totalDistribution(for natura:Arcana.Natura, normalized:Bool = false) -> Double {
                let sub = subDistribution(for: natura, normalized: normalized)
                let dist = distribution(for: natura, normalized: normalized)
                let total = sub + dist
                return total
            }
            
            public func distribution(for natura:Arcana.Natura, normalized:Bool = false) -> Double {
                switch natura {
                case .nether: return normalized ? nether.distribution/count : nether.distribution
                case .water: return normalized ? water.distribution/count : water.distribution
                case .void: return normalized ? void.distribution/count : void.distribution
                case .air: return normalized ? air.distribution/count : air.distribution
                case .aether: return normalized ? aether.distribution/count : aether.distribution
                case .earth: return normalized ? earth.distribution/count : earth.distribution
                case .core: return normalized ? core.distribution/count : core.distribution
                case .fire: return normalized ? fire.distribution/count : fire.distribution
                }
            }
            
            public func subDistribution(for natura:Arcana.Natura, normalized:Bool = false) -> Double {
                switch natura {
                case .nether: return normalized ? nether.subDistribution/count : nether.subDistribution
                case .water: return normalized ? water.subDistribution/count : water.subDistribution
                case .void: return normalized ? void.subDistribution/count : void.subDistribution
                case .air: return normalized ? air.subDistribution/count : air.subDistribution
                case .aether: return normalized ? aether.subDistribution/count : aether.subDistribution
                case .earth: return normalized ? earth.subDistribution/count : earth.subDistribution
                case .core: return normalized ? core.subDistribution/count : core.subDistribution
                case .fire: return normalized ? fire.subDistribution/count : fire.subDistribution
                }
            }
        }
        
        
    }
    
    

    /// Nature of Reality
    public enum Element:Int, CaseIterable {
        case fire
        case earth
        case air
        case water
        
        public static let superCount:Double = 12
        public static let count:Double = 4
        
        public static func from(degree:Degree) -> Element {
            var elementAccurate = ((((degree.value)/360)*superCount)).truncatingRemainder(dividingBy: count)
            if elementAccurate < 0 { elementAccurate += count }
            return Element(rawValue: Int(elementAccurate))!
        }
        
        public static func subFrom(degree: Degree) -> Element {
            var elementAccurate = (((degree.value)/360)*superCount).truncatingRemainder(dividingBy: count)
            if elementAccurate < 0 { elementAccurate += count }
            if elementAccurate.truncatingRemainder(dividingBy: 1) > 0.5 {
                var index = abs(Int(elementAccurate)+1)
                if index > Int(count)-1 { index = 0 }
                return Element(rawValue: index)!
            } else {
                var index = Int(elementAccurate)-1
                if index < 0 { index = Int(count)-1 }
                return Element(rawValue: index)!
            }
        }
        
        public var duality:Duality {
            switch self {
                case .air, .fire: return .yang
                case .earth, .water: return .yin
            }
        }
        
        public var image:StarKitImage {
            switch self {
            case .fire: return StarKitAssets.Images.NaturaSymbols.fire
            case .air: return StarKitAssets.Images.NaturaSymbols.air
            case .water: return StarKitAssets.Images.NaturaSymbols.water
            case .earth: return StarKitAssets.Images.NaturaSymbols.earth
            }
        }
    }
    
    /// Energy of the Cosmos
    public enum Force:Int, CaseIterable {
        case light
        case heat
        case magnetism
        case gravity
        
        public static let superCount:Double = 12
        public static let count:Double = 4
        
        public static func from(degree:Degree) -> Force {
            let degree = degree - 15
            var elementAccurate = ((((degree.value)/360)*superCount)).truncatingRemainder(dividingBy: count)
            if elementAccurate < 0 { elementAccurate += count }
            return Force(rawValue: Int(elementAccurate))!
        }
        
        public static func subFrom(degree: Degree) -> Force {
            let degree = degree - 15
            var elementAccurate = (((degree.value)/360)*superCount).truncatingRemainder(dividingBy: count)
            if elementAccurate < 0 { elementAccurate += count }
            if elementAccurate.truncatingRemainder(dividingBy: 1) > 0.5 {
                var index = abs(Int(elementAccurate)+1)
                if index > Int(count)-1 { index = 0 }
                return Force(rawValue: index)!
            } else {
                var index = Int(elementAccurate)-1
                if index < 0 { index = Int(count)-1 }
                return Force(rawValue: index)!
            }
        }
        
        public var duality:Duality {
            switch self {
                case .light, .magnetism: return .yang
                case .heat, .gravity: return .yin
            }
        }
        
        public var image:StarKitImage {
            switch self {
            case .light: return StarKitAssets.Images.NaturaSymbols.one
            case .heat: return StarKitAssets.Images.NaturaSymbols.many
            case .magnetism: return StarKitAssets.Images.NaturaSymbols.core
            case .gravity: return StarKitAssets.Images.NaturaSymbols.void
            }
        }
    }
    
    // MARK:
    
    /// 3 Frequency Types
    public enum Modality:Int, CaseIterable {
        case cardinal
        case fixed
        case mutable
        
        public var tao:Trinity {
            switch self {
                case .cardinal: return .tao
                case .fixed: return .yin
                case .mutable: return .yang
            }
        }
    }
    
    /// Purist Taoism - China Authority
    public enum Duality:Int, CaseIterable {
        case yin
        case yang
        
        public var tao:Trinity {
            switch self {
            case .yin: return .yin
            case .yang: return .yang
            }
        }
    }
    
    /// Real Taoism - Free Tibet
    public enum Trinity:Int, CaseIterable {
        case yin
        case yang
        case tao
    }
    
    /// Real Taoism - Free Tibet
    public enum CosmicForce:Int, CaseIterable {
        case positive
        case negative
        case spirit
        case body
        case holy
        case evil
        case core
        case void
        case chaos
        case order
        case alpha
        case omega
    }
    
    
    
}

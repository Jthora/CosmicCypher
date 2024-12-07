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
            
            
            public init(planetNodes: [CoreAstrology.AspectBody.NodeType:PlanetNode], limitList:[CoreAstrology.AspectBody.NodeType]? = nil , limitType:[PlanetNodeSubType]? = nil) {
                
                
                for (_,alignment) in planetNodes {
                    
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
        
        // Base36 Decans detection of a Decan that is a Prime Element (instead of one of the side decans)
        public static func isPrimeElement(degree: Degree) -> Bool {
            let zodiacDegree = ((((degree.value)/360)*superCount)).truncatingRemainder(dividingBy: 1)
            //print("isPrime(zodiacDegree: \(zodiacDegree))")
            return zodiacDegree > 0.333333 && zodiacDegree < 0.666667
        }
        
        public var duality:Duality {
            switch self {
                case .air, .fire: return .yang
                case .earth, .water: return .yin
            }
        }
        
        public var uiImage:UIImage {
            switch self {
            case .fire: return UIImage(named:"AstrologyIcon_Base16_Fire")!
            case .air: return UIImage(named:"AstrologyIcon_Base16_Air")!
            case .water: return UIImage(named:"AstrologyIcon_Base16_Water")!
            case .earth: return UIImage(named:"AstrologyIcon_Base16_Earth")!
            }
        }
        
        var text:String {
            switch self {
            case .fire: return "Fire"
            case .air: return "Air"
            case .water: return "Water"
            case .earth: return "Earth"
            }
        }
        
        var subtitle: String {
            switch self {
            case .fire: return "Passion and Energy"
            case .air: return "Intellect and Communication"
            case .water: return "Emotions and Intuition"
            case .earth: return "Stability and Practicality"
            }
        }
        
        var keywords: [String] {
            switch self {
            case .fire: return ["Passion", "Energy", "Action"]
            case .air: return ["Intellect", "Communication", "Adaptability"]
            case .water: return ["Emotions", "Intuition", "Empathy"]
            case .earth: return ["Stability", "Practicality", "Security"]
            }
        }
        
        var description: String {
            switch self {
            case .fire: return "Fire represents energy, passion, and creativity. It's associated with action and drive."
            case .air: return "Air embodies intellect, communication, and adaptability. It symbolizes thought and flexibility."
            case .water: return "Water symbolizes emotions, intuition, and empathy. It reflects sensitivity and depth."
            case .earth: return "Earth signifies stability, practicality, and security. It represents grounding and reliability."
            }
        }
        
        var details: String {
            switch self {
            case .fire: return "Fire elements are dynamic, enthusiastic, and often adventurous. They are driven by passion and a desire for change."
            case .air: return "Air elements are intellectual, communicative, and versatile. They thrive on exchanging ideas and adapt well to change."
            case .water: return "Water elements are emotional, intuitive, and compassionate. They feel deeply and are often empathetic towards others."
            case .earth: return "Earth elements are practical, reliable, and grounded. They value stability and work diligently towards their goals."
            }
        }
    }
    
    /// Energy of the Cosmos
    public enum Force:Int, CaseIterable {
        case heat // Chaos
        case magnetism // Core
        case light // Order
        case gravity // Void
        
        public static let superCount:Double = 12
        public static let count:Double = 4
        
        public static func from(degree:Degree) -> Force {
            var degree = Degree(((degree.value - 15) + 180).truncatingRemainder(dividingBy: 360))
            var elementAccurate = ((((degree.value)/360)*superCount)).truncatingRemainder(dividingBy: count) - 1
            if elementAccurate < 0 { elementAccurate += count }
            return Force(rawValue: Int(elementAccurate))!
        }
        
        public static func subFrom(degree: Degree) -> Force {
            var degree = Degree(((degree.value - 15) + 180).truncatingRemainder(dividingBy: 360))
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
        
        var text: String {
            switch self {
            case .cardinal: return "Cardinal"
            case .fixed: return "Fixed"
            case .mutable: return "Mutable"
            }
        }
        
        var altText: String {
            switch self {
            case .cardinal: return "Active"
            case .fixed: return "Static"
            case .mutable: return "Passive"
            }
        }
        
        var waveformText: String {
            switch self {
            case .cardinal: return "Triangle Waves"
            case .fixed: return "Square Waves"
            case .mutable: return "Sine Waves"
            }
        }
        
        var explanationText: String {
            switch self {
            case .cardinal: return "Cardinal modality initiates and starts new cycles, embodying the principle of movement and new beginnings."
            case .fixed: return "Fixed modality represents stability, persistence, and determination, embodying the principle of steadfastness."
            case .mutable: return "Mutable modality is adaptable, flexible, and changeable, embodying the principle of adaptability and transition."
            }
        }
        
        var principleText: String {
            switch self {
            case .cardinal: return "Movement, Action, and Initiation."
            case .fixed: return "Stability, Determination, and endurance."
            case .mutable: return "Principle: The mutable modality embodies the principle of adaptability, flexibility, and change."
            }
        }
        
        var uiImage: UIImage {
            switch self {
            case .cardinal: return UIImage(named: "AstrologyIcon_Base16_Alpha")!
            case .fixed: return UIImage(named: "AstrologyIcon_Base16_Order")!
            case .mutable: return UIImage(named: "AstrologyIcon_Base16_Omega")!
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

//
//  CosmicAlignment.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/26/20.
//

import Foundation

open class CosmicAlignment {
    
    // A Measure of the 4 Arcane Elements
    
    // Primary Elements (4)
    public var fire:Double = 0
    public var air:Double = 0
    public var earth:Double = 0
    public var water:Double = 0
    
    // total raw harmonic power
    public var total:Double {
        return fire + air + earth + water
    }
    
    public init(_ starChart:StarChart, selectedNodeTypes:[CoreAstrology.AspectBody.NodeType]) {
        let planetNodes = starChart.planetNodes.filter { (nodeType, node) in
            return selectedNodeTypes.contains(nodeType)
        }
        for planetNode in planetNodes {
            let chevron = planetNode.value.createChevron()
            switch chevron.element {
            case .fire: fire += chevron.elementDistribution
            case .earth: earth += chevron.elementDistribution
            case .air: air += chevron.elementDistribution
            case .water: water += chevron.elementDistribution
            }
            switch chevron.subElement {
            case .fire: fire += chevron.subElementDistribution
            case .earth: earth += chevron.subElementDistribution
            case .air: air += chevron.subElementDistribution
            case .water: water += chevron.subElementDistribution
            }
        }
    }
    
    public func level(_ elementReading:ElementReading, _ calc:ElementCalculation) -> Float {
        var level:Double = 0
        switch elementReading {
        case .fire: level = fire/total
        case .air: level = air/total
        case .water: level = water/total
        case .earth: level = earth/total
        case .poly: level = aether()
        case .mono: level = nether()
        case .light: level = holy(calc)
        case .shadow: level = evil(calc)
        case .spirit: level = spirit(calc)
        case .soul: level = body(calc)
        case .core: level = core(calc)
        case .void: level = void(calc)
        case .alpha: level = alpha(calc)
        case .omega: level = omega(calc)
        case .order: level = order(calc)
        case .chaos: level = chaos(calc)
        }
        return Float(level)
    }
    
    // Devine Elements (2)
    public func aether() -> Double  {
        // all for elements at equilibrium value
        // Resonance
        
        return 1 - nether()
    }
    
    public func nether() -> Double  {
        // amount of difference between elements and how close that is to net zero value
        // Disonance
        guard total != 0 else {
            return 1
        }
        
        // Normalize
        let fireRatio = fire/total
        let airRatio = air/total
        let earthRatio = earth/total
        let waterRatio = water/total
        
        // Disonance
        var disonance:Double = 0
        disonance += abs(fireRatio - airRatio)
        disonance += abs(fireRatio - earthRatio)
        disonance += abs(fireRatio - waterRatio)
        disonance += abs(airRatio - earthRatio)
        disonance += abs(airRatio - waterRatio)
        disonance += abs(waterRatio - earthRatio)
        
        return disonance
    }
    
    // 3rd Order Elements (4)
    public func holy(_ calc: ElementCalculation) -> Double {
        
        // Ratios
        let fireRatio = fire/total
        let airRatio = air/total
        let earthRatio = earth/total
        
        // Highest Value
        let localTotal = fireRatio + airRatio + earthRatio
        
        // Disonance Penalty
        var disonance:Double = 0
        disonance += abs(fireRatio - airRatio)
        disonance += abs(fireRatio - earthRatio)
        disonance += abs(airRatio - earthRatio)
        
        // Measurement Return
        switch calc {
        case .baseline: return localTotal - disonance
        case .expected: return localTotal - (disonance/3)
        case .potential: return localTotal
        }
    }
    
    public func evil(_ calc: ElementCalculation) -> Double {
        
        // Ratios
        let waterRatio = water/total
        let airRatio = air/total
        let earthRatio = earth/total
        
        // Highest Value
        let localTotal = waterRatio + airRatio + earthRatio
        
        // Disonance Penalty
        var disonance:Double = 0
        disonance += abs(waterRatio - airRatio)
        disonance += abs(waterRatio - earthRatio)
        disonance += abs(airRatio - earthRatio)
        
        // Measurement Return
        switch calc {
        case .baseline: return localTotal - disonance
        case .expected: return localTotal - (disonance/3)
        case .potential: return localTotal
        }
    }
    
    public func spirit(_ calc: ElementCalculation) -> Double {
        
        // Ratios
        let waterRatio = water/total
        let airRatio = air/total
        let fireRatio = fire/total
        
        // Highest Value
        let localTotal = waterRatio + airRatio + fireRatio
        
        // Disonance Penalty
        var disonance:Double = 0
        disonance += abs(waterRatio - airRatio)
        disonance += abs(waterRatio - fireRatio)
        disonance += abs(airRatio - fireRatio)
        
        // Measurement Return
        switch calc {
        case .baseline: return localTotal - disonance
        case .expected: return localTotal - (disonance/3)
        case .potential: return localTotal
        }
    }
    
    public func body(_ calc: ElementCalculation) -> Double {
        
        // Ratios
        let waterRatio = water/total
        let earthRatio = earth/total
        let fireRatio = fire/total
        
        // Highest Value
        let localTotal = waterRatio + earthRatio + fireRatio
        
        // Disonance Penalty
        var disonance:Double = 0
        disonance += abs(waterRatio - earthRatio)
        disonance += abs(waterRatio - fireRatio)
        disonance += abs(earthRatio - fireRatio)
        
        // Measurement Return
        switch calc {
        case .baseline: return localTotal - disonance
        case .expected: return localTotal - (disonance/3)
        case .potential: return localTotal
        }
    }
    
    // 2nd Order Elements (6)
    
    // Fire and Water
    public func chaos(_ calc: ElementCalculation) -> Double {
        
        // Ratios
        let waterRatio = water/total
        let fireRatio = fire/total
        
        // Highest Value
        let localTotal = waterRatio + fireRatio
        
        // Disonance Penalty
        var disonance:Double = 0
        disonance += abs(waterRatio - fireRatio)
        
        // Measurement Return
        switch calc {
        case .baseline: return localTotal - disonance
        case .expected: return localTotal - (disonance/2)
        case .potential: return localTotal
        }
    }
    
    public func order(_ calc: ElementCalculation) -> Double {
        
        // Ratios
        let earthRatio = earth/total
        let airRatio = air/total
        
        // Highest Value
        let localTotal = earthRatio + airRatio
        
        // Disonance Penalty
        var disonance:Double = 0
        disonance += abs(earthRatio - airRatio)
        
        // Measurement Return
        switch calc {
        case .baseline: return localTotal - disonance
        case .expected: return localTotal - (disonance/2)
        case .potential: return localTotal
        }
    }
    
    public func alpha(_ calc: ElementCalculation) -> Double {
        
        // Ratios
        let fireRatio = fire/total
        let airRatio = air/total
        
        // Highest Value
        let localTotal = fireRatio + airRatio
        
        // Disonance Penalty
        var disonance:Double = 0
        disonance += abs(fireRatio - airRatio)
        
        // Measurement Return
        switch calc {
        case .baseline: return localTotal - disonance
        case .expected: return localTotal - (disonance/2)
        case .potential: return localTotal
        }
    }
    
    public func omega(_ calc: ElementCalculation) -> Double {
        
        // Ratios
        let earthRatio = earth/total
        let waterRatio = water/total
        
        // Highest Value
        let localTotal = earthRatio + waterRatio
        
        // Disonance Penalty
        var disonance:Double = 0
        disonance += abs(earthRatio - waterRatio)
        
        // Measurement Return
        switch calc {
        case .baseline: return localTotal - disonance
        case .expected: return localTotal - (disonance/2)
        case .potential: return localTotal
        }
    }
    
    public func core(_ calc: ElementCalculation) -> Double {
        
        // Ratios
        let earthRatio = earth/total
        let fireRatio = fire/total
        
        // Highest Value
        let localTotal = earthRatio + fireRatio
        
        // Disonance Penalty
        var disonance:Double = 0
        disonance += abs(earthRatio - fireRatio)
        
        // Measurement Return
        switch calc {
        case .baseline: return localTotal - disonance
        case .expected: return localTotal - (disonance/2)
        case .potential: return localTotal
        }
    }
    
    public func void(_ calc: ElementCalculation) -> Double {
        
        // Ratios
        let waterRatio = water/total
        let airRatio = air/total
        
        // Highest Value
        let localTotal = waterRatio + airRatio
        
        // Disonance Penalty
        var disonance:Double = 0
        disonance += abs(waterRatio - airRatio)
        
        // Measurement Return
        switch calc {
        case .baseline: return localTotal - disonance
        case .expected: return localTotal - (disonance/2)
        case .potential: return localTotal
        }
    }
    
    public enum ElementCalculation {
        case baseline
        case expected
        case potential
    }
    
    public enum ElementReading {
        case fire
        case air
        case water
        case earth
        case poly
        case mono
        case spirit
        case light
        case shadow
        case soul
        case core
        case void
        case alpha
        case omega
        case order
        case chaos
    }
}

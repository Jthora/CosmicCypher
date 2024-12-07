//
//  CosmicAlignment.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 11/26/20.
//

import Foundation

class CosmicAlignment {
    
    // A Measure of the 4 Arcane Elements
    
    // Primary Elements (4)
    var fire:Double = 0
    var air:Double = 0
    var earth:Double = 0
    var water:Double = 0
    
    // total raw harmonic power
    var total:Double {
        return fire + air + earth + water
    }
    
    init(_ starChart:StarChart, limitList:[Astrology.AspectBody]? = nil) {
        
        for alignment in starChart.alignments where limitList == nil || limitList?.contains(alignment.value.aspectBody) == true {
            let chevron = alignment.value.createChevron()
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
    
    func level(_ elementReading:ElementReading, _ calc:ElementCalculation) -> Float {
        var level:Double = 0
        switch elementReading {
        case .fire: level = fire/total
        case .air: level = air/total
        case .water: level = water/total
        case .earth: level = earth/total
        case .aether: level = aether()
        case .nether: level = nether()
        case .holy: level = holy(calc)
        case .evil: level = evil(calc)
        case .spirit: level = spirit(calc)
        case .soul: level = soul(calc)
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
    func aether() -> Double  {
        // all for elements at equilibrium value
        // Resonance
        
        return 1 - nether()
    }
    
    func nether() -> Double  {
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
    func holy(_ calc: ElementCalculation) -> Double {
        
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
    
    func evil(_ calc: ElementCalculation) -> Double {
        
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
    
    func spirit(_ calc: ElementCalculation) -> Double {
        
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
    
    func soul(_ calc: ElementCalculation) -> Double {
        
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
    func chaos(_ calc: ElementCalculation) -> Double {
        
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
    
    func order(_ calc: ElementCalculation) -> Double {
        
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
    
    func alpha(_ calc: ElementCalculation) -> Double {
        
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
    
    func omega(_ calc: ElementCalculation) -> Double {
        
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
    
    func core(_ calc: ElementCalculation) -> Double {
        
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
    
    func void(_ calc: ElementCalculation) -> Double {
        
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
    
    enum ElementCalculation {
        case baseline
        case expected
        case potential
    }
    
    enum ElementReading {
        case fire
        case air
        case water
        case earth
        case aether
        case nether
        case spirit
        case holy
        case evil
        case soul
        case core
        case void
        case alpha
        case omega
        case order
        case chaos
    }
}

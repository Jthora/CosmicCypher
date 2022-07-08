//
//  ResonanceScore.swift
//  Project2501
//
//  Created by Jordan Trana on 4/27/22.
//

import Foundation


// MARK: Resonance Score
public extension StarChart {
    
    // Combination Data of Stellar Harmonics and Planetary Gravimetrics
    struct ResonanceScore {
        let harmonics: PlanetaryHarmonics.HarmonicsSample
        let energies: PlanetaryEnergyLevels.EnergyLevelsSample
        
        init(harmonics: PlanetaryHarmonics.HarmonicsSample, energies: PlanetaryEnergyLevels.EnergyLevelsSample) {
            self.harmonics = harmonics
            self.energies = energies
        }
        
        // What does the Resonance Score Measure?
        func measurements() {
            
        }
    }
    
    
}

// MARK: Resonance Score Methods
extension StarChart {
    
    // Returns the Total Resonance Score of 1 or more StarCharts
    public static func resonanceScore(from starCharts: [StarChart]) {
        
    }
    
    public func resonanceScore() -> ResonanceScore {
        return ResonanceScore(harmonics: self.planetaryHarmonics, energies: self.energyLevels)
    }
    
    public var planetaryHarmonics: PlanetaryHarmonics.HarmonicsSample {
        return PlanetaryHarmonics.HarmonicsSample(starChart: self)
    }
    public var energyLevels: PlanetaryEnergyLevels.EnergyLevelsSample {
        return PlanetaryEnergyLevels.EnergyLevelsSample(starChart: self)
    }
    
    
    enum ResonanceClassification {
        case raw
    }
}

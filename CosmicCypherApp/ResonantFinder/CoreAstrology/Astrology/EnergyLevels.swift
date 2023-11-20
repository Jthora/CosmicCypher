//
//  PlanetaryEnergyLevels.swift
//  Project2501
//
//  Created by Jordan Trana on 4/6/22.
//

import Foundation
import Combine
import SwiftAA



// MARK: Planetary Energy Levels
public class PlanetaryEnergyLevels: ObservableObject {
    
    // Electro Gravitics
    public typealias GravimetricMagnitude = Double // Gravity Field
    public typealias ElectrometricMagnitude = Double // ⚠️ Electric Field
    
    // Energy Level Samples
    @Published var latestSample:EnergyLevelsSample? = nil
    @Published var samples:[Date:EnergyLevelsSample] = [:]
    
    // Absolute Energy Range
    @Published var minGlobalAbsoluteEnergy:GravimetricMagnitude? = nil
    @Published var maxGlobalAbsoluteEnergy:GravimetricMagnitude? = nil
    @Published var minInterPlanetaryAbsoluteEnergy:GravimetricMagnitude? = nil
    @Published var maxInterPlanetaryAbsoluteEnergy:GravimetricMagnitude? = nil
    @Published var minStellarAbsoluteEnergy:GravimetricMagnitude? = nil
    @Published var maxStellarAbsoluteEnergy:GravimetricMagnitude? = nil
    
    // Net Energy Range
    @Published var minGlobalNetEnergy:GravimetricMagnitude? = nil
    @Published var maxGlobalNetEnergy:GravimetricMagnitude? = nil
    @Published var minStellarNetEnergy:GravimetricMagnitude? = nil
    @Published var maxStellarNetEnergy:GravimetricMagnitude? = nil
    
    // Energy Tension Range
    @Published var minGlobalEnergyTension:GravimetricMagnitude? = nil
    @Published var maxGlobalEnergyTension:GravimetricMagnitude? = nil
    @Published var minStellarEnergyTension:GravimetricMagnitude? = nil
    @Published var maxStellarEnergyTension:GravimetricMagnitude? = nil
    
    // Energy Freedom Range
    @Published var minGlobalEnergyFreedom:GravimetricMagnitude? = nil
    @Published var maxGlobalEnergyFreedom:GravimetricMagnitude? = nil
    @Published var minStellarEnergyFreedom:GravimetricMagnitude? = nil
    @Published var maxStellarEnergyFreedom:GravimetricMagnitude? = nil
    
    public func calculateEnergies(date: Date = Date(), coordinates: GeographicCoordinates = GeographicCoordinates(positivelyWestwardLongitude: -122, latitude: 47)) {
        
        let starChart = StarChart(date: date,
                                  coordinates: coordinates,
                                  celestialOffset: .galacticCenter)
        
        let sample = EnergyLevelsSample(starChart: starChart)
        
        updateMinMaxValues(for: sample)
        latestSample = sample
        samples[date] = sample
    }
    
    // Set Min and Max range
    public func updateMinMaxValues(for sample:EnergyLevelsSample) {
        // Global Min Max
        minGlobalAbsoluteEnergy = min(minGlobalAbsoluteEnergy ?? sample.globalAbsoluteEnergy, sample.globalAbsoluteEnergy)
        maxGlobalAbsoluteEnergy = max(maxGlobalAbsoluteEnergy ?? sample.globalAbsoluteEnergy, sample.globalAbsoluteEnergy)
        minGlobalNetEnergy = min(minGlobalNetEnergy ?? sample.globalNetEnergy, sample.globalNetEnergy)
        maxGlobalNetEnergy = max(maxGlobalNetEnergy ?? sample.globalNetEnergy, sample.globalNetEnergy)
        minGlobalEnergyTension = max(minGlobalEnergyTension ?? sample.globalEnergyTension, sample.globalEnergyTension)
        maxGlobalEnergyTension = min(maxGlobalEnergyTension ?? sample.globalEnergyTension, sample.globalEnergyTension)
        minGlobalEnergyFreedom = max(minGlobalEnergyFreedom ?? sample.globalEnergyFreedom, sample.globalEnergyFreedom)
        maxGlobalEnergyFreedom = min(maxGlobalEnergyFreedom ?? sample.globalEnergyFreedom, sample.globalEnergyFreedom)
        
        // Interplanetary Min Max
        minInterPlanetaryAbsoluteEnergy = min(minInterPlanetaryAbsoluteEnergy ?? sample.interPlanetaryAbsoluteEnergy, sample.interPlanetaryAbsoluteEnergy)
        maxInterPlanetaryAbsoluteEnergy = max(maxInterPlanetaryAbsoluteEnergy ?? sample.interPlanetaryAbsoluteEnergy, sample.interPlanetaryAbsoluteEnergy)
        
        // Stellar Min Max
        minStellarAbsoluteEnergy = min(minStellarAbsoluteEnergy ?? sample.stellarAbsoluteEnergy, sample.stellarAbsoluteEnergy)
        maxStellarAbsoluteEnergy = max(maxStellarAbsoluteEnergy ?? sample.stellarAbsoluteEnergy, sample.stellarAbsoluteEnergy)
        minStellarNetEnergy = min(minStellarNetEnergy ?? sample.stellarNetEnergy, sample.stellarNetEnergy)
        maxStellarNetEnergy = max(maxStellarNetEnergy ?? sample.stellarNetEnergy, sample.stellarNetEnergy)
        minStellarEnergyTension = max(minStellarEnergyTension ?? sample.stellarEnergyTension, sample.stellarEnergyTension)
        maxStellarEnergyTension = min(maxStellarEnergyTension ?? sample.stellarEnergyTension, sample.stellarEnergyTension)
        minStellarEnergyFreedom = max(minStellarEnergyFreedom ?? sample.stellarEnergyFreedom, sample.stellarEnergyFreedom)
        maxStellarEnergyFreedom = min(maxStellarEnergyFreedom ?? sample.stellarEnergyFreedom, sample.stellarEnergyFreedom)
    }
    
    public var currentEnergyLevels: EnergyLevelsSample? {
        return getEnergyLevels(for: Date())
    }
    
    // Get Energy Levels (using Date)
    public func getEnergyLevels(for selectedDate: Date) -> EnergyLevelsSample? {
        
        /// Dates are directly reference-able
        if let sample = samples[selectedDate] { return sample }
        
        /// Do Time Travel Search
        var timeIntervalSince:TimeInterval = TimeInterval.greatestFiniteMagnitude
        var closestDate: Date? = nil
        for (sampleDate,_) in samples {
            let newTimeIntervalSince = TimeInterval.minimum(timeIntervalSince, abs(selectedDate.timeIntervalSince(sampleDate)))
            if timeIntervalSince != newTimeIntervalSince {
                closestDate = sampleDate
                timeIntervalSince = newTimeIntervalSince
            }
        }
        
        /// Return Findings
        if let date = closestDate {
            return samples[date]
        }
        return nil
    }
}

// MARK: Normalized Energy Levels
extension PlanetaryEnergyLevels {
    
    // Normalized Energy level
    public func normalizedEnergyLevel( centricPoint: CentricPoint, energyLevelType: EnergyLevelType, date:Date? = nil, height: Double = 1) -> Double {
        switch energyLevelType {
        case .absolute: return normalizedAbsoluteEnergy(for: date, centricPoint: centricPoint, height: height)
        case .net: return normalizedNetEnergy(for: date, centricPoint: centricPoint, height: height)
        case .tension: return normalizedEnergyTension(for: date, centricPoint: centricPoint, height: height)
        case .free: return normalizedEnergyFreedom(for: date, centricPoint: centricPoint, height: height)
        }
    }
    
    // Normalized Net Energy
    public func normalizedNetEnergy(for sampleDate:Date? = nil, centricPoint: CentricPoint = .global, height: Double = 1) -> Double {
        
        guard let date = sampleDate,
              let energyLevels = getEnergyLevels(for: date) else { return 0 }
        
        /// Calculate Normalized Values
        switch centricPoint {
        case .stellar:
            guard let minStellarNetEnergy = minStellarNetEnergy,
                  let maxStellarNetEnergy = maxStellarNetEnergy else { return 0 }
            let normalizedNetEnergyLevel = (energyLevels.stellarNetEnergy - minStellarNetEnergy) / (maxStellarNetEnergy - minStellarNetEnergy)
            return normalizedNetEnergyLevel * height
        case .global:
            guard let minGlobalNetEnergy = minGlobalNetEnergy,
                  let maxGlobalNetEnergy = maxGlobalNetEnergy else { return 0 }
            let normalizedNetEnergyLevel = (energyLevels.globalNetEnergy - minGlobalNetEnergy) / (maxGlobalNetEnergy - minGlobalNetEnergy)
            return normalizedNetEnergyLevel * height
        case .interPlanetary:
            return 0
        }
    }
    
    // Normalized Absolute Energy
    public func normalizedAbsoluteEnergy(for sampleDate:Date? = nil, centricPoint: CentricPoint = .global,  height: Double = 1) -> Double {
        
        guard let date = sampleDate,
              let energyLevels = getEnergyLevels(for: date) else { return 0 }
        
        /// Calculate Normalized Values
        switch centricPoint {
        case .stellar:
            guard let minStellarAbsoluteEnergy = minStellarAbsoluteEnergy,
                  let maxStellarAbsoluteEnergy = maxStellarAbsoluteEnergy else { return 0 }
            let normalizedAbsoluteEnergyLevel = (energyLevels.stellarAbsoluteEnergy - minStellarAbsoluteEnergy) / (maxStellarAbsoluteEnergy - minStellarAbsoluteEnergy)
            return normalizedAbsoluteEnergyLevel * height
        case .global:
            guard let minGlobalAbsoluteEnergy = minGlobalAbsoluteEnergy,
                  let maxGlobalAbsoluteEnergy = maxGlobalAbsoluteEnergy else { return 0 }
            let normalizedAbsoluteEnergyLevel = (energyLevels.globalAbsoluteEnergy - minGlobalAbsoluteEnergy) / (maxGlobalAbsoluteEnergy - minGlobalAbsoluteEnergy)
            return normalizedAbsoluteEnergyLevel * height
        case .interPlanetary:
            guard let minInterPlanetaryAbsoluteEnergy = minInterPlanetaryAbsoluteEnergy,
                  let maxInterPlanetaryAbsoluteEnergy = maxInterPlanetaryAbsoluteEnergy else { return 0 }
            let normalizedAbsoluteEnergyLevel = (energyLevels.interPlanetaryAbsoluteEnergy - minInterPlanetaryAbsoluteEnergy) / (maxInterPlanetaryAbsoluteEnergy - minInterPlanetaryAbsoluteEnergy)
            return normalizedAbsoluteEnergyLevel * height
        }
    }
    
    // Normalized Energy Tension
    public func normalizedEnergyTension(for sampleDate:Date? = nil, centricPoint: CentricPoint = .global,  height: Double = 1) -> Double {
        
        guard let date = sampleDate,
              let energyLevels = getEnergyLevels(for: date) else { return 0 }
        
        /// Calculate Normalized Values
        switch centricPoint {
        case .stellar:
            guard let minStellarEnergyTension = minStellarEnergyTension,
                  let maxStellarEnergyTension = maxStellarEnergyTension else { return 0 }
            let normalizedEnergyTensionLevel = (energyLevels.stellarEnergyTension - minStellarEnergyTension) / (maxStellarEnergyTension - minStellarEnergyTension)
            return normalizedEnergyTensionLevel * height
        case .global:
            guard let minGlobalEnergyTension = minGlobalEnergyTension,
                  let maxGlobalEnergyTension = maxGlobalEnergyTension else { return 0 }
            let normalizedEnergyTensionLevel = (energyLevels.globalEnergyTension - minGlobalEnergyTension) / (maxGlobalEnergyTension - minGlobalEnergyTension)
            return normalizedEnergyTensionLevel * height
        case .interPlanetary:
            return 0
        }
    }
    
    // Normalized Energy Tension
    public func normalizedEnergyFreedom(for sampleDate:Date? = nil, centricPoint: CentricPoint = .global,  height: Double = 1) -> Double {
        
        guard let date = sampleDate,
              let energyLevels = getEnergyLevels(for: date) else { return 0 }
        
        /// Calculate Normalized Values
        switch centricPoint {
        case .stellar:
            guard let minStellarEnergyTension = minStellarEnergyTension,
                  let maxStellarEnergyTension = maxStellarEnergyTension else { return 0 }
            let normalizedEnergyTensionLevel = (energyLevels.stellarEnergyTension - minStellarEnergyTension) / (maxStellarEnergyTension - minStellarEnergyTension)
            return normalizedEnergyTensionLevel * height
        case .global:
            guard let minGlobalEnergyTension = minGlobalEnergyTension,
                  let maxGlobalEnergyTension = maxGlobalEnergyTension else { return 0 }
            let normalizedEnergyTensionLevel = (energyLevels.globalEnergyTension - minGlobalEnergyTension) / (maxGlobalEnergyTension - minGlobalEnergyTension)
            return normalizedEnergyTensionLevel * height
        case .interPlanetary:
            return 0
        }
    }
    
    
    
}

// MARK: Types
extension PlanetaryEnergyLevels {
    
    // Relative Perspective (The Center focal point to calculate Gravimetric Energy Levels)
    public enum CentricPoint {
        case stellar /// Heliocentric Sun  (gravimetric energy acted on the sun)
        case global /// Geocentric Earth  (gravimetric energy acted on the earth)
        case interPlanetary /// Interplanetary Web Collective Energy  (gravimetric energy collectively acted on between all major astronomical bodies in or star system)
    }
    
    //Energy Level Type
    public enum EnergyLevelType {
        case absolute /// Total Energy Acted on each Point
        case net /// Relative Energy Acted on each Point
        case tension /// Amount of Energy Wasted 'fighting against itself'
        case free /// Amount of openly available Energy which ebbs and flows
    }
}

// MARK: Planetary Energy Levels Sample
extension PlanetaryEnergyLevels {
    
    public struct EnergyLevelsSample: Comparable {
        public static func < (lhs: PlanetaryEnergyLevels.EnergyLevelsSample, rhs: PlanetaryEnergyLevels.EnergyLevelsSample) -> Bool {
            guard let d1 = lhs.date,
                  let d2 = rhs.date else {
                return false
            }
            return d1 < d2
        }
        
        public var date:Date? = nil
        
        // Geo Centric Earth
        public var globalAbsoluteEnergy:GravimetricMagnitude = 0
        public var globalNetEnergy:GravimetricMagnitude = 0
        public var globalEnergyTension: GravimetricMagnitude { return abs(globalAbsoluteEnergy) - abs(globalNetEnergy) }
        public var globalEnergyFreedom: GravimetricMagnitude { return 1 - globalEnergyTension }
        
        // Inter Planetary Web
        public var interPlanetaryAbsoluteEnergy:GravimetricMagnitude = 0
        
        // Helio Centric Sun
        public var stellarAbsoluteEnergy:GravimetricMagnitude = 0
        public var stellarNetEnergy:GravimetricMagnitude = 0
        public var stellarEnergyTension: GravimetricMagnitude { return abs(stellarAbsoluteEnergy) - abs(stellarNetEnergy) }
        public var stellarEnergyFreedom: GravimetricMagnitude {  return 1 - stellarEnergyTension }
        
        public init() { }
        
        public init(starChart: StarChart) {
            globalAbsoluteEnergy = starChart.globalAbsoluteGravimetricMagnitude()
            globalNetEnergy = starChart.globalNetGravimetricMagnitude()
            
            interPlanetaryAbsoluteEnergy = starChart.interplanetaryAbsoluteGravimentricMagnitude()
            
            stellarAbsoluteEnergy = starChart.stellarAbsoluteGravimentricMagnitude()
            stellarNetEnergy = starChart.stellarNetGravimentricMagnitude()
        }
        
        public  init(globalAbsoluteEnergy:GravimetricMagnitude , globalNetEnergy:GravimetricMagnitude) {
            self.globalAbsoluteEnergy = globalAbsoluteEnergy
            self.globalNetEnergy = globalNetEnergy
        }
    }
}


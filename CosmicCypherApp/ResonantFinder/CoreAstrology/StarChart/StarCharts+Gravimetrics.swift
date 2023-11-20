//
//  StarCharts+Gravimetrics.swift
//  Project2501
//
//  Created by Jordan Trana on 4/27/22.
//

import Foundation
import SwiftAA

// MARK: Gravimetric Magnitude
extension StarChart {
    
    // INTERPLANETARY -- All Planet Cores to All Planet Cores (interplanetary web)
    // GLOBAL -- Earth Center Core (geocentric)
    // STELLAR -- Sun Center Core (heliocentric)
    
    // LOCAL -- Earth Surface Location (geographic coordinates + time)
    // PERSONAL -- Relationship between a given Chart with another Date/Time on Earth (geographic coordinates + time)*2
    // INTERPERSONAL -- Relationship between Two Charts at a Date/Time on Earth (geographic coordinates + time)*3
    // GROUP -- Many Chart Relationships and their interacting web results
    
    // MARK: Global Gravimetric Magnitude
    
    public func globalAbsoluteGravimetricMagnitude(includeSun:Bool = false) -> Double {
        var absoluteMagnitude:Double = 0
        for aspectBody in CoreAstrology.AspectBody.NodeType.bodiesWithGravity where includeSun ? true : aspectBody != .sun {
            absoluteMagnitude += aspectBody.gravimetricForceOnEarth(date: date)?.value ?? 0
        }
        return absoluteMagnitude
    }
    
    // use ecliptic
    public func globalNetGravimetricMagnitude(includeSun:Bool = false) -> Double {
        let tensor = globalNetGravimetricTensor(includeSun: includeSun)
        return tensor.magnitude
    }
    
    public func globalNetGravimetricTensor(includeSun:Bool = false) -> CoreAstrology.GravimetricTensor {
        var globalGravitationalTensor = CoreAstrology.GravimetricTensor.empty
        for aspectBody in CoreAstrology.AspectBody.NodeType.bodiesWithGravity where includeSun ? true : aspectBody != .sun {
            globalGravitationalTensor += aspectBody.geocentricGravimetricTensor(date: date)
        }
        return globalGravitationalTensor
    }
    
    // MARK: Interplanetary Gravimetric Magnitude
    
    public func interplanetaryAbsoluteGravimentricMagnitude(includeSun: Bool = true) -> Double {
        let startDate = Date()
        var interplanetaryGravitationalMagnitude: Double = 0
        //print("Interplanetary Gravimetric Magnitude (start): \(startDate.timeIntervalSinceNow)")
        for p1 in CoreAstrology.AspectBody.NodeType.bodiesWithGravity {
            //print("Interplanetary Gravimetric Magnitude (\(p1)): \(startDate.timeIntervalSinceNow)")
            for p2 in CoreAstrology.AspectBody.NodeType.bodiesWithGravity where p1 != p2 && (p1 != .moon && p2 != .moon) && !(includeSun == true && (p1 == .sun || p2 == .sun)) {
                //print("Interplanetary Gravimetric Magnitude (\(p2)): \(startDate.timeIntervalSinceNow)")
                interplanetaryGravitationalMagnitude += p1.gravimetricForceBetween(otherPlanet: p2, date: self.date)?.value ?? 0
            }
        }
        //print("Interplanetary Gravimetric Magnitude (end): \(startDate.timeIntervalSinceNow)")
        return interplanetaryGravitationalMagnitude
    }
    
    
    // MARK: Stellar Gravimetric Magnitude
    
    public func stellarAbsoluteGravimentricMagnitude() -> Double {
        var stellarAbsoluteGravimentricMagnitude: Double = 0
        let p1: CoreAstrology.AspectBody.NodeType = .sun
        for p2 in CoreAstrology.AspectBody.NodeType.bodiesWithGravity {
            stellarAbsoluteGravimentricMagnitude += p1.gravimetricForceBetween(otherPlanet: p2, date: self.date)?.value ?? 0
        }
        return stellarAbsoluteGravimentricMagnitude
        
    }
    
    public func stellarNetGravimentricMagnitude() -> Double {
        return stellarNetGravimentricTensor().magnitude
    }
    
    public func stellarNetGravimentricTensor() -> CoreAstrology.GravimetricTensor {
        var stellarNetGravimentricTensor = CoreAstrology.GravimetricTensor.empty
        for aspectBody in CoreAstrology.AspectBody.NodeType.bodiesWithGravity where aspectBody != .moon {
            stellarNetGravimentricTensor += aspectBody.heliocentricGravimetricTensor(date: date)
        }
        return stellarNetGravimentricTensor
    }
    
    public func stellarGravimentricTensor() {
        
    }
    
    
    // MARK: Local Gravimetric Magnitude
    
    public func localAbsoluteGravimetricTensor(bodyMass:Kilogram = 155, geographicCoordinates: GeographicCoordinates, date: Date) -> CoreAstrology.GravimetricTensor {
        let localGravitationalTensor = CoreAstrology.GravimetricTensor.empty
        
        // Slighly Less Accurate, but effective enough... Instead just add Earth Tensor using IC (opposite of mid-heaven) with Earth Gravity for Magnitude
        
        
        // Highly Accurate Version
        // Use a Geo-Location Coordinate and Earth Date
        // Inquire SwiftAA about the Locations of Each Planet during Earth Date
        // Calculate Distance between Geo-Location Coordinate and Each Planet (including Earth and Sun)
        // Fetch Angle for Localized Harmonic Calculation is Mid-Heaven (Relative to IC which can be used as the Tensor Angle for Earth Gravity)
        // Add Individual Tensor Magnitudes
        
        return localGravitationalTensor
    }
    
    public func localNetGravimetricTensor(bodyMass:Kilogram = 155, geographicCoordinates: GeographicCoordinates, date: Date) -> CoreAstrology.GravimetricTensor {
        let localGravitationalTensor = CoreAstrology.GravimetricTensor.empty
        
        // Use a Geo-Location Coordinate and Earth Date
        // Inquire SwiftAA for Angular Sky Positions of Each Planet during Earth Date relative to Earth
        // Calculate Distance between Geo-Location Coordinate and Each Planet (including Earth and Sun)
        // Angle for Localized Harmonic Calculation is Mid-Heaven (Relative to IC which can be used as the Tensor Angle for Earth Gravity)
        // Add Tensors Together
        
        
        return localGravitationalTensor
    }
    
}

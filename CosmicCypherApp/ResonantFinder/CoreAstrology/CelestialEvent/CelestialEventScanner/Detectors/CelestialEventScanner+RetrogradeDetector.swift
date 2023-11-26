//
//  CelestialEventScanner+RetrogradeDetector.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/20/23.
//

import Foundation
import SwiftAA // Accurate Astronomy

// MARK: Retrograde Detector
extension CelestialEventScanner {
    // Retrograde Detector
    class RetrogradeDetector {
        
        // MARK: Properties
        // Vector Memory for Retrograde Motion Detection
        var previousT1:TimeInterval? = nil
        var previousL1:Degree? = nil
        var previousSpeed1:DegreesPerSecond? = nil
        var previousSpeedDelta1:DegreesPerSecondPerSecond? = nil
        
        // MARK: Methods
        // Get Motion State
        func cycleMotionState(for planetNodeType:PlanetNodeType, timeInterval:TimeInterval) -> PlanetNodeState.MotionState? {
            // Aspect Body 
            /// Perform a binary search to find the closest aspect date
            let date = Date(timeIntervalSinceReferenceDate: timeInterval)
            guard let b1 = CoreAstrology.AspectBody(type: planetNodeType, date: date) else {
                // No Aspect Body
                return nil
            }
            
            // Longitude
            let l1 = b1.equatorialLongitude
            let t1 = timeInterval
            
            // Previous Longitude
            guard previousL1 != nil,
                  previousT1 != nil else {
                /// Initialize Previous l1
                previousL1 = l1
                previousT1 = t1
                return nil
            }
            /// New Longitude Speed
            let newSpeed1: Degree = previousL1! - l1
            /// Reset Previous Longitudes
            previousL1 = l1
            previousT1 = t1
            
            // Handle New Speed Deltas
            guard previousSpeed1 != nil else {
                // Initialize Previous Speeds
                previousSpeed1 = newSpeed1
                return nil
            }
            // New Speed Delta
            let newSpeedDelta1: Degree = previousSpeed1! - newSpeed1
            /// Reset Previous Speeds
            previousSpeed1 = newSpeed1
            
            // Check Previous Delta (Acceleration/Deceleration)
            /// Get Momentum Speed Flux tracking via Velocity Delta of Equatorial Longitude Degree
            guard previousSpeedDelta1 != nil else {
                previousSpeedDelta1 = newSpeedDelta1
                return nil
            }
            // Momentum
            let b1Momentum = PlanetNodeState.MotionState.Motion.Momentum(degrees: newSpeedDelta1)
            /// Reset Previous Speed Deltas
            previousSpeedDelta1 = newSpeedDelta1
            
            // Motion
            let b1Motion: PlanetNodeState.MotionState.Motion
            
            // b1 Retrograde Motion Detection
            if (previousL1!+360) > (l1+360) {
                /// Retrograde Flag b1
                b1Motion = .retrograde(b1Momentum)
            } else if (previousL1!+360) < (l1+360) {
                /// Direct Flag b1
                b1Motion = .direct(b1Momentum)
            } else {
                /// Stationary Flag b1
                b1Motion = .stationary
            }
            
            // Return Motion State
            let motionState = PlanetNodeState.MotionState(b1Motion, speed: newSpeed1)
            return motionState
        }
    }
}

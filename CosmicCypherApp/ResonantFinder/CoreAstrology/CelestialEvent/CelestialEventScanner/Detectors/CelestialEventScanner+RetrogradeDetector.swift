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
        var previousTimeDuration:TimeInterval? = nil
        var previousLongDistance:Double? = nil
        var previousSpeed:DegreesPerSecond? = nil
        var previousSpeedDelta:DegreesPerSecondPerSecond? = nil
        
        // MARK: Cycle
        // Cycle Motion State
        /// Iterate for a next data set of planet node information
        func cycleMotionState(planetNodeType:PlanetNodeType, date:Date) -> PlanetNodeState.MotionState? {
            // Aspect Body
            /// Perform a binary search to find the closest aspect date
            guard let b = CoreAstrology.AspectBody(type: planetNodeType, date: date) else {
                // No Aspect Body
                return nil
            }
            return cycleMotionState(l: b.equatorialLongitude.value,
                                        t: date.timeIntervalSinceReferenceDate)
        }
        
        // Cycle Motion State from PlanetNode
        func cycleMotionState(planetNode:PlanetNode, date:Date) -> PlanetNodeState.MotionState? {
            return cycleMotionState(l: planetNode.longitude.value,
                                    t: date.timeIntervalSinceReferenceDate)
        }
        
        // Cycle Motion State from Raw Values
        func cycleMotionState(l:Double, t:TimeInterval) -> PlanetNodeState.MotionState? {
            // Previous Longitude
            guard previousLongDistance != nil,
                  previousTimeDuration != nil else {
                /// Initialize Previous l1
                previousLongDistance = l
                previousTimeDuration = t
                return nil
            }
            /// New Longitude Speed
            let angleDiff = angleDifference(angle1: previousLongDistance!, angle2: l)
            let newSpeed = DegreesPerSecond(angleDiff/(previousTimeDuration! - t))
            /// Reset Previous Longitudes
            previousLongDistance = l
            previousTimeDuration = t
            
            // Handle New Speed Deltas
            guard previousSpeed != nil else {
                // Initialize Previous Speeds
                previousSpeed = newSpeed
                return nil
            }
            // New Speed Delta
            let newSpeedDelta: Degree = previousSpeed! - newSpeed
            /// Reset Previous Speeds
            previousSpeed = newSpeed
            
            // Check Previous Delta (Acceleration/Deceleration)
            /// Get Momentum Speed Flux tracking via Velocity Delta of Equatorial Longitude Degree
            guard previousSpeedDelta != nil else {
                previousSpeedDelta = newSpeedDelta
                return nil
            }
            // Momentum
            let momentum = PlanetNodeState.MotionState.Motion.Momentum(degrees: newSpeedDelta)
            
            /// Reset Previous Speed Deltas
            previousSpeedDelta = newSpeedDelta
            
            // Motion
            let motion: PlanetNodeState.MotionState.Motion
            
            // b1 Retrograde Motion Detection
            if newSpeed > 0 {
                /// Direct Flag b1
                motion = .direct(momentum)
            } else if newSpeed < 0 {
                /// Retrograde Flag b1
                motion = .retrograde(momentum)
            } else {
                /// Stationary Flag b1
                motion = .stationary
            }
            
            // Return Motion State
            let motionState = PlanetNodeState.MotionState(motion, speed: newSpeed, speedDelta: newSpeedDelta)
            return motionState
        }
        
        // MARK: Supporting Methods
        
        // Angle Difference
        public func angleDifference(angle1: Double, angle2: Double ) -> Double {
            let diff: Double = ( angle2 - angle1 + 180.0 ).truncatingRemainder(dividingBy: 360.0) - 180.0
            return diff < -180 ? diff + 360 : diff
        }
    }
}

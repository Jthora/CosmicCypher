//
//  CelestialEventScanner+RetrogradeDeepScanner.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/26/23.
//

import Foundation
import SwiftAA

// MARK: Retrograde Deep Scanner
extension CelestialEventScanner.RetrogradeEventScanner {
    // Deep Scanner
    class DeepScanner {
        
        // MARK: Properties
        // Previous
        /// Planet Node States
        var previousMotionState:PlanetNodeState.MotionState? = nil
        
        // MARK: Deep Scan
        // Scan
        func deepScan(planetNodeType: PlanetNodeType,
                      startDate: Date,
                      endDate: Date,
                      onProgress:((_ progress:Float) -> Void)? = nil,
                      onComplete:((_ date:Date) -> Void)? = nil) {
            calculateAspectDateTime(planetNodeType: planetNodeType,
                                    startDate: startDate,
                                    endDate: endDate,
                                    onProgress: onProgress,
                                    onComplete: onComplete)
        }
        
        // Calculate
        private func calculateAspectDateTime(planetNodeType: PlanetNodeType,
                                             startDate: Date,
                                             endDate: Date,
                                             onProgress:((_ progress:Float) -> Void)? = nil,
                                             onComplete:((_ date:Date) -> Void)? = nil) {
            
            Task {
                // Target Values
                let targetOrbThreshold = 0.01 // Set the target orb threshold to 0.01 degrees
                
                // Calculate the TimeInterval for 24 hours
                let halfDay: TimeInterval = 12 * 60 * 60
                
                // Calculate the TimeInterval range for 24 hours before and after the estimatedDate
                let startTimeInterval = startDate.timeIntervalSinceReferenceDate
                let endTimeInterval = endDate.timeIntervalSinceReferenceDate
                
                // Date
                var minDistance = Double.greatestFiniteMagnitude
                
                // Bounds
                var lowerBoundTimeInterval = startTimeInterval
                var upperBoundTimeInterval = endTimeInterval
                
                // Total
                let total = upperBoundTimeInterval - lowerBoundTimeInterval
                
                // On Progress
                onProgress?(0)
                
                // Retrograde Compensator
                let retrogradeDetector1 = CelestialEventScanner.RetrogradeDetector()
                let retrogradeDetector2 = CelestialEventScanner.RetrogradeDetector()
                
                // Handle Retrograde/Direct Motion Detection - binary search loop
                /// Retrograde Handling using Planetary Motion and Speed
                while upperBoundTimeInterval - lowerBoundTimeInterval >= 1.0 {
                    // Deep Scan - Loop Iterator
                    
                    // Temporal gap
                    let current = upperBoundTimeInterval - lowerBoundTimeInterval
                    
                    // On Progress
                    let progress = Float((total-current)/total)
                    onProgress?(progress)
                    
                    // MidTime
                    let midTimeInterval = (lowerBoundTimeInterval + upperBoundTimeInterval) / 2.0
                    
                    // Body
                    let midDate = Date(timeIntervalSinceReferenceDate: midTimeInterval)
                    guard let b1 = CoreAstrology.AspectBody(type: planetNodeType, date: midDate) else {
                        continue
                    }
                    
                    // Motion
                    guard let motionState = retrogradeDetector1.cycleMotionState(l: b1.equatorialLongitude.value, t: midTimeInterval) else {
                        continue
                    }
                    
                    // TODO: Use Speed and Momentum to create dynamic Orb for accurate realtime tracking
                    let speed = motionState.speed
                    switch motionState.motion {
                    case .direct(let momentum):
                        // Expand Upper Bounds
                        break
                    case .retrograde(let momentum):
                        // Expand Lower Bounds
                        break
                    case .stationary:
                        break
                    }
                }
                
                onProgress?(1)
            }
        }
    }
}

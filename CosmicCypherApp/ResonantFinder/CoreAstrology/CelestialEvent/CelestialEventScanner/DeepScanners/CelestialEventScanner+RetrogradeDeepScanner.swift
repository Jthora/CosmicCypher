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
        func deepScan(motion m1: PlanetNodeState.MotionState.Motion,
                      changedTo m2: PlanetNodeState.MotionState.Motion,
                      planetNodeType: PlanetNodeType,
                      startDate: Date,
                      endDate: Date,
                      onProgress:((_ progress:Float) -> Void)? = nil) -> Date {
            return calculateRetrogradeTime(motion: m1,
                                           changedTo: m2,
                                           planetNodeType: planetNodeType,
                                           startDate: startDate,
                                           endDate: endDate,
                                           onProgress: onProgress)
        }
        
        // Calculate
        private func calculateRetrogradeTime(motion m1: PlanetNodeState.MotionState.Motion,
                                             changedTo m2: PlanetNodeState.MotionState.Motion,
                                             planetNodeType: PlanetNodeType,
                                             startDate: Date,
                                             endDate: Date,
                                             onProgress:((_ progress:Float) -> Void)? = nil) -> Date {
            
            // Current Date
            var resultDate:Date? = nil
            
            // Check
            if m1 == m2 {
                return Date.midDate(between: startDate, and: endDate)
            }
            
            let rs1 = m1.retrogradeState()
            let rs2 = m2.retrogradeState()
            
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
            let initialTimeBounds = upperBoundTimeInterval - lowerBoundTimeInterval
            
            // On Progress
            onProgress?(0)
            
            // Retrograde Compensator
            let detector = Detector()
            
            // Handle Retrograde/Direct Motion Detection - (Binary Search Loop for Retrograde Detection)
            /// Retrograde Handling using Planetary Motion and Speed
            while upperBoundTimeInterval - lowerBoundTimeInterval >= 1.0 {
                // Deep Scan - Loop Iterator
                
                // Temporal gap
                let timeBounds = upperBoundTimeInterval - lowerBoundTimeInterval // Narrows until it reaches 1 second in size
                
                // On Progress
                let progress = Float((initialTimeBounds-timeBounds)/initialTimeBounds)
                onProgress?(progress)
                
                // MidTime
                let midTimeInterval = (lowerBoundTimeInterval + upperBoundTimeInterval) / 2.0
                
                // Date
                let midDate = Date(timeIntervalSinceReferenceDate: midTimeInterval)
                let newStartDate = Date(timeIntervalSinceReferenceDate: lowerBoundTimeInterval)
                let newEndDate = Date(timeIntervalSinceReferenceDate: upperBoundTimeInterval)
                
                // Planet Motion
                let retrogradeState1 = detector.detectRetrograde(planetNodeType:planetNodeType,
                                                                 pastDate:newStartDate,
                                                                 futureDate:midDate)
                let retrogradeState2 = detector.detectRetrograde(planetNodeType:planetNodeType,
                                                                 pastDate:midDate,
                                                                 futureDate:newEndDate)
                
                // How can I use retrogradeState1, retrogradeState2, rs1 and rs2 to figure out which if to cut out the lower or upper bounds?
                
                // If ??? then cut off lower bounds (past)
                // If ??? then cut off upper bounds (future)
                
                
                // Check and compare with the motion input to change the bounds
                if rs1 == retrogradeState1 && rs2 == retrogradeState2 { /// Match
                    lowerBoundTimeInterval = midTimeInterval
                } else if rs1 == retrogradeState2 && rs2 == retrogradeState1 { /// Mixup
                    upperBoundTimeInterval = midTimeInterval
                } else { /// Miss
                    /// Decide whether to adjust bounds or not based on your logic
                }
                
                // Handle for these cases
                if rs1 != retrogradeState1 && rs2 != retrogradeState2 {
                    /// Both Not Equal
                    // TODO: Handle for if they are not equal
                } else if rs1 == retrogradeState1 && rs2 == retrogradeState1 {
                    /// Both are retrogradeState1
                    // Logic for consistent retrograde motion (if any)
                } else if rs1 == retrogradeState2 && rs2 == retrogradeState2 {
                    /// Both are retrogradeState2
                    // Logic for consistent stationary motion (if any)
                }
            }
            
            onProgress?(1)
            return resultDate ?? Date.midDate(between: startDate, and: endDate)
        }
    }
}


extension CelestialEventScanner.RetrogradeEventScanner.DeepScanner {
    class Detector {
        func detectRetrograde(planetNodeType:PlanetNodeType, pastDate:Date, futureDate:Date) -> PlanetNodeRetrogradeState {
            guard let past = CoreAstrology.AspectBody(type: planetNodeType, date: pastDate),
                  let future = CoreAstrology.AspectBody(type: planetNodeType, date: futureDate) else {
                return .direct
            }
            let l1 = past.equatorialLongitude
            let l2 = future.equatorialLongitude
            
            // Detect Direction
            if l2 < l1 {
                return .retrograde
            } else if l2 > l1 {
                return .direct
            } else {
                return .stationary
            }
        }
    }
}

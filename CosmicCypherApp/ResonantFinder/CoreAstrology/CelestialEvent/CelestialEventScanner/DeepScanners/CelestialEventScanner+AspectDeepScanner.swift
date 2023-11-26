//
//  CelestialEventScanner+AspectDeepScanner.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/7/23.
//

import Foundation
import SwiftAA

// MARK: Deep Scanner
extension CelestialEventScanner.AspectEventScanner {
    // Deep Scanner
    class DeepScanner {
        
        // MARK: Properties
        // Previous
        /// Planet Node States
        var previousPlanetNodeState1:PlanetNodeState.MotionState? = nil
        var previousPlanetNodeState2:PlanetNodeState.MotionState? = nil
        
        // MARK: Deep Scan
        // Scan
        func deepScan(aspect: CoreAstrology.Aspect,
                      for estimatedDate: Date,
                      onProgress:((_ progress:Float) -> Void)? = nil,
                      onComplete:((_ date:Date) -> Void)? = nil) {
            calculateAspectDateTime(estimatedDate: estimatedDate,
                                    primaryObject: aspect.primaryBody,
                                    secondaryObject: aspect.secondaryBody,
                                    aspectRelation: aspect.relation,
                                    onProgress: onProgress,
                                    onComplete: onComplete)
        }
        
        // Calculate
        private func calculateAspectDateTime(estimatedDate: Date,
                                             primaryObject: CoreAstrology.AspectBody,
                                             secondaryObject: CoreAstrology.AspectBody,
                                             aspectRelation: CoreAstrology.AspectRelation,
                                             onProgress:((_ progress:Float) -> Void)? = nil,
                                             onComplete:((_ date:Date) -> Void)? = nil) {
            
            Task {
                // Target Values
                let targetAspectType = aspectRelation.type
                let targetAspectAngle = targetAspectType.degree.value
                let targetOrbThreshold = 0.01 // Set the target orb threshold to 0.01 degrees
                
                // AspectBody.NodeType
                let p1Type = primaryObject.type
                let p2Type = secondaryObject.type
                
                // Calculate the TimeInterval for 24 hours
                let halfDay: TimeInterval = 12 * 60 * 60
                
                // Calculate the TimeInterval range for 24 hours before and after the estimatedDate
                let startTimeInterval = estimatedDate.timeIntervalSinceReferenceDate - halfDay
                let endTimeInterval = estimatedDate.timeIntervalSinceReferenceDate + halfDay
                
                // Date
                var closestDate = estimatedDate
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
                    
                    // TODO: Use PlanetNodeState Speed and Momentum to create dynamic Orb for accurate realtime tracking
                    
                    let current = upperBoundTimeInterval - lowerBoundTimeInterval
                    
                    // On Progress
                    let progress = Float((total-current)/total)
                    onProgress?(progress)
                    
                    // Planet Motions (retrogrades)
                    /// Perform a binary search to find the closest aspect date
                    // Motion
                    let midTimeInterval = (lowerBoundTimeInterval + upperBoundTimeInterval) / 2.0
                    guard let motion1 = retrogradeDetector1.cycleMotionState(for: p1Type, timeInterval: midTimeInterval),
                          let motion2 = retrogradeDetector2.cycleMotionState(for: p2Type, timeInterval: midTimeInterval) else {
                        continue
                    }
                    var speed1:DegreesPerSecond = motion1.speed
                    var speed2:DegreesPerSecond = motion2.speed
                    switch motion1.currentMotion {
                    case .direct(let momentum):
                        // Expand Upper Bounds
                        break
                    case .retrograde(let momentum):
                        // Expand Lower Bounds
                        break
                    case .stationary:
                        break
                    }
                    switch motion2.currentMotion {
                    case .direct(let momentum):
                        // Expand Upper Bounds
                        break
                    case .retrograde(let momentum):
                        // Expand Lower Bounds
                        break
                    case .stationary:
                        break
                    }
                    
                    // Body
                    let midDate = Date(timeIntervalSinceReferenceDate: midTimeInterval)
                    guard let b1 = CoreAstrology.AspectBody(type: p1Type, date: midDate),
                          let b2 = CoreAstrology.AspectBody(type: p2Type, date: midDate) else {
                        continue
                    }
                    // Longitude Difference
                    guard let longitudeDifference: Degree = b1.longitudeDifference(from: b2, on: midDate) else {continue}
                    
                    
                    // Calculate the aspect angle between the two planetary bodies
                    let distance = abs(longitudeDifference.value - targetAspectAngle)
                    
                    if distance < minDistance {
                        minDistance = distance
                        closestDate = midDate
                    }
                    
                    // Check if the aspect angle is within the target orb threshold
                    if distance < targetOrbThreshold {
                        break
                    }
                }
                
                onProgress?(1)
                onComplete?(closestDate)
            }
        }
    }
}

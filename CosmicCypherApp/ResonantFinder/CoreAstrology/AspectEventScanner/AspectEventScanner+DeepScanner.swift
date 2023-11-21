//
//  AspectEventScanner+DeepScanner.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/7/23.
//

import Foundation
import SwiftAA

// MARK: Deep Scanner
extension AspectEventScanner {
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
                
                // Binary search loop
                while upperBoundTimeInterval - lowerBoundTimeInterval >= 1.0 {
                    
                    
                    // Loop Iterator
                    let current = upperBoundTimeInterval - lowerBoundTimeInterval
                    onProgress?(Float((total-current)/total))
                    
                    /// Perform a binary search to find the closest aspect date
                    let midTimeInterval = (lowerBoundTimeInterval + upperBoundTimeInterval) / 2.0
                    let midDate = Date(timeIntervalSinceReferenceDate: midTimeInterval)
                    
                    guard let b1 = CoreAstrology.AspectBody(type: p1Type, date: midDate),
                          let b2 = CoreAstrology.AspectBody(type: p2Type, date: midDate),
                          let longitudeDifference: Degree = b1.longitudeDifference(from: b2, on: midDate) else {
                        break
                    }
                    
                    // Planet Node States
                    let planetNodeState1 = p1Type.generatePlanetNodeState(date: estimatedDate, highPrecision: true)
                    let planetNodeState2 = p2Type.generatePlanetNodeState(date: estimatedDate, highPrecision: true)
                    
                    
                    // TODO: Retrograde Handling using Planetary Motion and Speed
                    
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

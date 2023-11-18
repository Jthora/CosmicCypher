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
    
    class DeepScanner {
        // Deep Scanner
        func deepScan(aspect: CoreAstrology.Aspect, for estimatedDate: Date) -> Date {
            let aspectDate = calculateAspectDateTime(estimatedDate: estimatedDate,
                                                     primaryObject: aspect.primaryBody,
                                                     secondaryObject: aspect.secondaryBody,
                                                     aspectRelation: aspect.relation)
            return aspectDate
        }
        
        private func calculateAspectDateTime(estimatedDate: Date,
                                             primaryObject: CoreAstrology.AspectBody,
                                             secondaryObject: CoreAstrology.AspectBody,
                                             aspectRelation: CoreAstrology.AspectRelation) -> Date {
            
            let targetAspectType = aspectRelation.type
            let targetAspectAngle = targetAspectType.degree.value
            let targetOrbThreshold = 0.01 // Set the target orb threshold to 0.01 degrees
            
            let p1Type = primaryObject.type
            let p2Type = secondaryObject.type
            
            // Calculate the TimeInterval for 24 hours
            let halfDay: TimeInterval = 12 * 60 * 60
            
            // Calculate the TimeInterval range for 24 hours before and after the estimatedDate
            let startTimeInterval = estimatedDate.timeIntervalSinceReferenceDate - halfDay
            let endTimeInterval = estimatedDate.timeIntervalSinceReferenceDate + halfDay
            
            var closestDate = estimatedDate
            var minDistance = Double.greatestFiniteMagnitude
            
            var lowerBoundTimeInterval = startTimeInterval
            var upperBoundTimeInterval = endTimeInterval
            
            while upperBoundTimeInterval - lowerBoundTimeInterval >= 1.0 {
                // Perform a binary search to find the closest aspect date
                let midTimeInterval = (lowerBoundTimeInterval + upperBoundTimeInterval) / 2.0
                let midDate = Date(timeIntervalSinceReferenceDate: midTimeInterval)
                
                guard let b1 = CoreAstrology.AspectBody(type: p1Type, date: midDate),
                      let b2 = CoreAstrology.AspectBody(type: p2Type, date: midDate),
                      let longitudeDifference: Degree = b1.longitudeDifference(from: b2, on: midDate) else {
                    break
                }
                
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
                
                // Update the bounds based on motion state or other heuristics
                //updateBoundsBasedOnMotion(&lowerBoundTimeInterval, &upperBoundTimeInterval, distance, targetAspectAngle)
            }
            
            return closestDate
        }
        
    //    private func updateBoundsBasedOnMotion(_ lowerBound: inout TimeInterval, _ upperBound: inout TimeInterval, _ currentDistance: Double, _ targetAngle: Double) {
    //        let motionThreshold = 1.0 // Adjust this threshold as needed
    //
    //        // Determine the motion state based on the current distance and target angle
    //        let motionState: NodeState.Motion
    //        if currentDistance < motionThreshold {
    //            motionState = .stationary
    //        } else if currentDistance < targetAngle {
    //            motionState = .retrograde
    //        } else {
    //            motionState = .direct
    //        }
    //
    //        // Update the bounds based on the motion state
    //        switch motionState {
    //        case .stationary:
    //            // No adjustment needed, the aspect is stationary
    //        case .retrograde:
    //            // Adjust the lower bound for retrograde motion
    //            lowerBound += 1.0 // You may need to fine-tune this value
    //        case .direct:
    //            // Adjust the upper bound for direct motion
    //            upperBound -= 1.0 // You may need to fine-tune this value
    //        }
    //    }
    }
    

}

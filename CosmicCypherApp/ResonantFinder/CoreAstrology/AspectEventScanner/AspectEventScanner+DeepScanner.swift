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
            
            // Binary search loop
            while upperBoundTimeInterval - lowerBoundTimeInterval >= 1.0 {
                
                /// Perform a binary search to find the closest aspect date
                let midTimeInterval = (lowerBoundTimeInterval + upperBoundTimeInterval) / 2.0
                let midDate = Date(timeIntervalSinceReferenceDate: midTimeInterval)
                
                guard let b1 = CoreAstrology.AspectBody(type: p1Type, date: midDate),
                      let b2 = CoreAstrology.AspectBody(type: p2Type, date: midDate),
                      let longitudeDifference: Degree = b1.longitudeDifference(from: b2, on: midDate) else {
                    break
                }
                
                /// Check Retrogrades
                
                
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
            
            return closestDate
        }
    }
    

}

extension CoreAstrology.Aspect {
    
}

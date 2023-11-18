//
//  AspectEventScanner+Scan.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/7/23.
//

import Foundation
import SwiftAA

extension AspectEventScanner {
    
    // MARK: Scan
    class Scanner {
        
        // Delegate
        public var delegate:AspectEventScannerDelegate? = nil
        
        // State
        private var _state:State = .ready
        public var state:State {
            get {
                return _state
            }
            set {
                _state = newValue
            }
        }
        
        // Parsing Buffers
        var activelyScanningAspectEvents:[CoreAstrology.AspectType.SymbolHash: CoreAstrology.AspectEvent] = [:]
        var recentlyLockedInAspectTypes:[CoreAstrology.AspectType.SymbolHash: Bool] = [:]
        
        // Locked In Aspects
        public var lockedInAspects: [Date: [CoreAstrology.Aspect]] = [:]
        func lockIn(aspect: CoreAstrology.Aspect, for date:Date) {
            var aspectArray:[CoreAstrology.Aspect] = lockedInAspects[date] ?? []
            aspectArray.append(aspect)
            lockedInAspects[date] = aspectArray
        }
        
        // Reset Scanner
        func resetScanner() {
            activelyScanningAspectEvents = [:]
            recentlyLockedInAspectTypes = [:]
            lockedInAspects = [:]
            state = .ready
        }
        
        // Start Scanner
        func startScanner(startDate:Date, 
                          endDate:Date) {
            resetScanner()
            state = .scanning
            
            // Make Sure that Start Date isn't the same as End Date
            guard startDate != endDate else {
                //didError?(.startAndEndDateAreSame)
                delegate?.scanError(error: .startAndEndDateAreSame)
                return
            }

            // Get Total Scans based on the number of Days between Start Date and End Date
            guard let totalScanCount = daysBetweenDates(startDate: startDate, endDate: endDate) else {
                delegate?.scanError(error: .cannotGetTotalScanCountFromDates)
                //didError?(.cannotGetTotalScanCountFromDates)
                return
            }
            
            // Find Aspects
            // Establish a list of Types for Bodies and Relations (Planets and Angles)
            let relationTypes: Set<CoreAstrology.AspectRelationType> = Set(AspectEventScanner.Core.aspectAngles)
            let nodeTypes: Set<CoreAstrology.AspectBody.NodeType> = Set(AspectEventScanner.Core.planetsAndNodes)
            
            // List AspectTypes
            let aspectTypes = createListOfAspectTypes(relationTypes: relationTypes, nodeTypes: nodeTypes)
            //print("Aspects To Scan: \(aspectTypes.map({$0.hash}))")
            
            // Scan for Aspects
            scan(startDate: startDate,
                 endDate: endDate,
                 aspectTypes: aspectTypes,
                 totalScanCount: totalScanCount)//aspectTypes: aspectTypes, totalScanCount: totalScanCount)
        }
        
        
        // Create a list of all the aspect types we are scanning
        func createListOfAspectTypes(relationTypes:Set<CoreAstrology.AspectRelationType>, nodeTypes:Set<CoreAstrology.AspectBody.NodeType>) -> [CoreAstrology.AspectType] {
            
            // Setup for creating List
            let nodeTypes = nodeTypes.enumerated()
            var aspectTypes:[CoreAstrology.AspectType] = []
            
            // Iterate through each Body Type (for first body)
            for (index1, nodeType1) in nodeTypes {
                
                // Iterate through each Body Type (for second body)
                for (_, nodeType2) in nodeTypes.dropFirst(index1 + 1) { // Avoid duplicate and reverse combinations
                    
                    // Iterate through each Aspect Type
                    for relationType in relationTypes {
                        let aspectType = CoreAstrology.AspectType(primaryBodyType: nodeType1, relationType: relationType, secondaryBodyType: nodeType2)
                        aspectTypes.append(aspectType)
                    }
                }
            }
            return aspectTypes
        }
        
        // Go through every day and scan for Aspects that are within orb
        func scan(startDate:Date, 
                  endDate:Date,
                  aspectTypes: [CoreAstrology.AspectType],
                  totalScanCount:Float,
                  didUpdate:((_ progress:Float)->Void)? = nil,
                  didComplete:((_ aspectsFound:[Date: [CoreAstrology.Aspect]])->Void)? = nil,
                  didError:((_ error:AspectEventScanner.ScanError)->Void)? = nil) {
            //print("scanning aspects")
            
            // Perform on Background Thread
            DispatchQueue.global(qos: .userInitiated).async {
                
                // Scanning Properties
                var currentDate = startDate
                var scanCount: Float = 0
                
                var timeDelta: TimeInterval = Date().timeIntervalSinceReferenceDate
                
                
                // Scanning Loop
                while currentDate <= endDate {
                    // Number of Iterations
                    scanCount += 1
                    let progress = scanCount / totalScanCount
                    
                    // Report progress to Console UI
                    DispatchQueue.main.async {
                        AspectEventScanner.Core.console.scanning(scans: Int(scanCount),
                                               scrying: self.activelyScanningAspectEvents.count,
                                               discovered: self.lockedInAspects.count)
                        didUpdate?(progress)
                        //print("timeDelta: \(Date().timeIntervalSinceReferenceDate-timeDelta) (scanUpdate(progress:))")
                    }
                    
                    // Find Aspects within Orb
                    //print("finding aspects for types: \(aspectTypes.map({$0.hash}))")
                    let aspects = self.findAspectsWithinOrb(aspectTypes: aspectTypes, on: currentDate)
                    //print("found aspects: \(aspects.map({$0.hash}))")
                    //print("timeDelta: \(Date().timeIntervalSinceReferenceDate-timeDelta) (findAspectsWithinOrb)")
                    
                    // Calculate Aspects
                    self.calculate(aspects: aspects, on: currentDate)
                    //print("timeDelta: \(Date().timeIntervalSinceReferenceDate-timeDelta) (calculate(aspects:))")

                    // determine the next scan date
                    currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
                }
                
                // Report Complete to Delegate
                didComplete?(self.lockedInAspects)
            }
        }
        
        // Find Aspects for Date based on Types
        func findAspectsWithinOrb(aspectTypes:[CoreAstrology.AspectType],
                                  on date:Date,
                                  didUpdate:((_ progress:Float)->Void)? = nil,
                                  didComplete:((_ aspects:[CoreAstrology.Aspect])->Void)? = nil,
                                  didError:((_ error:AspectEventScanner.ScanError)->Void)? = nil) -> [CoreAstrology.Aspect] {
            var aspects: [CoreAstrology.Aspect] = []
            for (i,aspectType) in aspectTypes.enumerated() {
                
                // Report Progress Bar
                DispatchQueue.main.async {
                    let subProgress:Float = Float(i) / Float(aspectTypes.count)
                    didUpdate?(subProgress)
                }
                
                //print("checking orb for: \(aspectType.hash)")
                guard let aspect = aspectType.aspect(for: date) else {continue}
                //print("found aspect within orb: \(aspect.hash)")
                aspects.append(aspect)
            }
            // Report Progress Bar
            DispatchQueue.main.async {
                didUpdate?(0)
            }
            return aspects
        }
        
        // Cycle through Aspects and Planets looking for Orbs at 0º
        func calculate(aspects:[CoreAstrology.Aspect], on currentDate:Date) {
            //print("Calculating: \(currentDate)")
            
            
            // TODO: ⚠️ Create Solution to compensate for Retrogrades:
            /// Detect Retrogrades, Stationary and Direct motions.
            /// Track Retrogrades
            /// use enum for Motion
            /// Expand Scanner Bounds based on Motion Distance Change
            /// Use high-calc Time Skipper for Bounds Expansion
            /// Cancel if Out-of-Orb
            
            
            // Iterate through Aspects
            let aspectsList = aspects.enumerated()
            for (i, currentAspect) in aspectsList {
                //print("Iterating: \(currentAspect.hash)")
                
                // Report Progress Bar
                DispatchQueue.main.async {
                    let subProgress:Float = Float(i) / Float(aspects.count)
                    //self.delegate?.scanUpdate(progress: nil, subProgress: subProgress)
                }
                
                // Symbol Hash
                let hash = currentAspect.hash
                
                // Current Aspect Distance
                guard let currentDistance = currentAspect.longitudeDifference(for: currentDate) else {
                    //print("Skipping \(hash) (FAILURE to get longitudeDifference for \(currentAspect) on \(currentDate)")
                    continue
                }
                
                // Ensure that aspect isn't Recently Locked In
                guard recentlyLockedInAspectTypes[hash] == nil else {
                    //print("Skipping \(hash) (recently Locked In)")
                    continue // Skip to next aspect
                }
                
                // If Previous Aspect exists, compare with Current Aspect
                if let previousAspectEvent = activelyScanningAspectEvents[hash] {
                    //print("Comparing \(previousAspectEvent.aspect.type.hash) with \(currentAspect.type.hash)")
                    
                    // Previous Date, Aspect and Distance
                    let previousDate = previousAspectEvent.date
                    let previousAspect = previousAspectEvent.aspect
                    guard let previousDistance = previousAspect.longitudeDifference(for: previousDate) else {
                        //print("Skipping \(hash) (FAILURE to get longitudeDifference for \(previousAspect) on \(previousDate))")
                        continue
                    }
                    
                    // Is current aspect closer to 0º than previous?
                    let isCloser = abs(currentDistance) <= abs(previousDistance)
                    
                    // If closer, update aspect
                    if isCloser {
                        //print("Closing In on (\(hash)) for [\(currentDate)] at [\(currentDistance)]")
                        
                        // Update Aspect because it's closer to 0º orb
                        activelyScanningAspectEvents[hash] = CoreAstrology.AspectEvent(aspect: currentAspect, date: currentDate)
                    } else {
                        //print("Locking In (\(hash)) for [\(previousDate)] at [\(previousDistance)]")
                        
                        // No longer Actively Scanning Aspect
                        self.activelyScanningAspectEvents.removeValue(forKey: hash)
                        
                        // Deep Scan to aquire the Exact Time of Date for the Aspect Event
                        let realDate = deepScan(aspect: previousAspect, for: previousDate)
                        guard let realAspect = CoreAstrology.Aspect(type: previousAspect.type, date: realDate) else {
                            //print("FailureToGetRealDate \(previousAspect): \(realDate)")
                            
                            //self.handleScanError(error: .failureToGetRealDate, context: "\(previousAspect): \(realDate)")
                            delegate?.scanError(error: .failureToGetRealDate)
                            continue
                        }
                        
                        // Lock In the Aspect
                        lockIn(aspect: realAspect, for: realDate)
                        
                        // Set that the Aspect was recently Locked in
                        recentlyLockedInAspectTypes[hash] = true
                    }
                    
                } else {
                    // No Previous Aspect Date (initial state) add
                    //print("Newly detected Aspect \(hash)")
                    activelyScanningAspectEvents[hash] = CoreAstrology.AspectEvent(aspect: currentAspect, date: currentDate)
                }
            }

            //print("Considering removal of locked in aspects...")
            // remove recentlyLockedInAspects that are no longer being detected
            let symbolHashes = aspects.map { $0.hash }
            
            // Check all Recently Locked In Aspects to see if they are no longer being considered for active scan
            for (key, _) in recentlyLockedInAspectTypes {
                // Remove Recently Locked In Flag, as it's not being scanned anymore and may appear again in the future
                if !symbolHashes.contains(key) {
                    //print("Clearing recently locked in aspect: \(key)")
                    recentlyLockedInAspectTypes.removeValue(forKey: key)
                }
            }
            
            // Reset Progress Bar
            DispatchQueue.main.async {
                self.delegate?.scanUpdate(scanProgress: nil)
            }
        }
        
        // Get the number of days between two dates
        func daysBetweenDates(startDate: Date, endDate: Date) -> Float? {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.day], from: startDate, to: endDate)
            guard let days = dateComponents.day else {return nil}
            return Float(days)
        }
        
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
    }
}

//
//  AspectEventScanner+Scanner.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/7/23.
//

import Foundation
import SwiftAA

// MARK: Scanner
extension AspectEventScanner {
    // Scanner
    class Scanner {
        // Delegate
        public var delegate:AspectEventScannerDelegate? = nil
        public var deepScanner = DeepScanner()
        
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
        var activelyScanningAspectEvents:[CoreAstrology.AspectType.SymbolHash: CoreAstrology.CelestialEvent] = [:]
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
                delegate?.scanError(error: .startAndEndDateAreSame)
                return
            }

            // Get Total Scans based on the number of Days between Start Date and End Date
            guard let totalScanCount = daysBetweenDates(startDate: startDate, endDate: endDate) else {
                delegate?.scanError(error: .cannotGetTotalScanCountFromDates)
                return
            }
            
            // Find Aspects
            /// Establish a list of Types for Bodies and Relations (Planets and Angles)
            let relationTypes: Set<CoreAstrology.AspectRelationType> = Set(AspectEventScanner.Core.aspectAngles)
            let nodeTypes: Set<CoreAstrology.AspectBody.NodeType> = Set(AspectEventScanner.Core.planetsAndNodes)
            
            // List AspectTypes
            let aspectTypes = createListOfAspectTypes(relationTypes: relationTypes, nodeTypes: nodeTypes)
            
            // Scan for Aspects
            scan(startDate: startDate,
                 endDate: endDate,
                 aspectTypes: aspectTypes,
                 totalScanCount: totalScanCount)
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
                  totalScanCount:Float) {
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
                        self.delegate?.scanUpdate(scanProgress: progress)
                    }
                    
                    // Find Aspects within Orb
                    let aspects = self.findAspectsWithinOrb(aspectTypes: aspectTypes, on: currentDate)
                    
                    // Calculate Aspects
                    self.calculate(aspects: aspects, on: currentDate)

                    // determine the next scan date
                    currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
                }
                
                // Report Complete to Delegate
                DispatchQueue.main.async {
                    self.delegate?.scanComplete(aspectsFound: self.lockedInAspects)
                }
            }
        }
        
        // Find Aspects for Date based on Types
        func findAspectsWithinOrb(aspectTypes:[CoreAstrology.AspectType], on date:Date) -> [CoreAstrology.Aspect] {
            
            /// Loop through aspects
            var aspects: [CoreAstrology.Aspect] = []
            for (i,aspectType) in aspectTypes.enumerated() {
                
                /// Report Progress Bar
                DispatchQueue.main.async {
                    let subScanProgress:Float = Float(i) / Float(aspectTypes.count)
                    self.delegate?.scanUpdate(subScanProgress: subScanProgress)
                }
                
                /// Aspect
                guard let aspect = aspectType.aspect(for: date) else {
                    delegate?.scanError(error: .cannotGetTotalScanCountFromDates)
                    continue
                }
                aspects.append(aspect)
            }
            
            /// Report to Progress Bar
            DispatchQueue.main.async {
                self.delegate?.scanUpdate(subScanProgress: 0)
            }
            return aspects
        }
        
        // Cycle through Aspects and Planets looking for Orbs at 0º
        func calculate(aspects:[CoreAstrology.Aspect],
                       on currentDate:Date,
                       onComplete:((_ date:Date) -> Void)? = nil) {
            // Iterate through Aspects
            let aspectsList = aspects.enumerated()
            for (i, currentAspect) in aspectsList {
                
                // Report Progress Bar
                DispatchQueue.main.async {
                    let subScanProgress:Float = Float(i) / Float(aspects.count)
                    self.delegate?.scanUpdate(subScanProgress: subScanProgress)
                }
                
                // Symbol Hash
                let hash = currentAspect.hash
                // Current Aspect Distance
                guard let currentDistance = currentAspect.longitudeDifference(for: currentDate) else {
                    delegate?.scanError(error: .skippingHashFailureToGetLongitudeDifferenceForPreviousAspectOnPreviousDate("\(hash)"))
                    continue
                }
                
                // Ensure that aspect isn't Recently Locked In
                guard recentlyLockedInAspectTypes[hash] == nil else {
                    delegate?.scanError(error: .recentlyLockedInAspectTypesMissing)
                    continue // Skip to next aspect
                }
                
                // If Previous Aspect exists, compare with Current Aspect
                if let previousAspectEvent = activelyScanningAspectEvents[hash] {
                    
                    // Previous Date, Aspect and Distance
                    let previousDate = previousAspectEvent.date
                    let previousAspect = previousAspectEvent.aspect
                    guard let previousDistance = previousAspect.longitudeDifference(for: previousDate) else {
                        delegate?.scanError(error: .recentlyLockedInAspectTypesMissing)
                        continue
                    }
                    
                    // Is current aspect closer to 0º than previous?
                    let isCloser = abs(currentDistance) <= abs(previousDistance)
                    
                    // If closer, update aspect
                    if isCloser {
                        // Update Aspect because it's closer to 0º orb
                        activelyScanningAspectEvents[hash] = CoreAstrology.CelestialEvent(aspect: currentAspect, date: currentDate)
                    } else {
                        // No longer Actively Scanning Aspect
                        self.activelyScanningAspectEvents.removeValue(forKey: hash)
                        
                        // Deep Scan to aquire the Exact Time of Date for the Aspect Event
                        getAccurateDate(aspect: previousAspect,
                                        for: previousDate,
                                        onComplete: { realDate in
                            // Real Aspect from Real Date
                            guard let realAspect = CoreAstrology.Aspect(type: previousAspect.type, date: realDate) else {
                                self.delegate?.scanError(error: .failureToGetRealAspect)
                                return
                            }
                            
                            // Lock In the Real Aspect with the Real Date
                            self.lockIn(aspect: realAspect, for: realDate)
                            
                            // Back call
                            onComplete?(realDate)
                        })
                        
                        // Set that the Aspect was recently Locked in
                        recentlyLockedInAspectTypes[hash] = true
                    }
                    
                } else {
                    // No Previous Aspect Date (initial state) add
                    activelyScanningAspectEvents[hash] = CoreAstrology.CelestialEvent(aspect: currentAspect, date: currentDate)
                }
            }

            // remove recentlyLockedInAspects that are no longer being detected
            let symbolHashes = aspects.map { $0.hash }
            
            // Check all Recently Locked In Aspects to see if they are no longer being considered for active scan
            for (key, _) in recentlyLockedInAspectTypes {
                // Remove Recently Locked In Flag, as it's not being scanned anymore and may appear again in the future
                if !symbolHashes.contains(key) {
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
            guard let days = dateComponents.day else {
                self.delegate?.scanError(error: .cannotGetTotalScanCountFromDates)
                return nil
            }
            return Float(days)
        }
        
        // MARK: Deep Scan
        // Get Accurate Date and Time
        func getAccurateDate(aspect: CoreAstrology.Aspect, 
                             for estimatedDate: Date,
                             onComplete:((_ date:Date) -> Void)? = nil) {
            deepScanner.deepScan(aspect: aspect,
                                 for: estimatedDate,
                                 onProgress: { progress in DispatchQueue.main.async { self.delegate?.scanUpdate(deepScanProgress: progress) } },
                                 onComplete: onComplete)
        }
    }
}
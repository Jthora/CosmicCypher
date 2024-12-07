//
//  CelestialEventScanner+RetrogradeEventScanner.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/26/23.
//

import Foundation

// MARK: Retrograde Scanner
extension CelestialEventScanner {
    // Retrograde Scanner
    class RetrogradeEventScanner: SubScanner {
        
        // Properties
        public var useDeepScan: Bool = true
        public var sampleMode:SampleMode = .minute
        private var deepScanner = DeepScanner()
        
        // MARK: Scan for Retrogrades
        // Scan
        func scan(startDate: Date, endDate:Date, planetNodeTypes: [PlanetNodeType]) -> ScanResults {
            
            // Time Variables
            let et = endDate.timeIntervalSinceReferenceDate
            let st = startDate.timeIntervalSinceReferenceDate
            let td = sampleMode.timeInterval
            var t = st
            
            // Detectors
            var detectors:[PlanetNodeType:RetrogradeDetector] = [:]
            var previousMotionStates:[PlanetNodeType:PlanetNodeState.MotionState] = [:]
            
            var results:ScanResults = [:]
            
            // Loop
            /// Do While Time is before End Date
            while t < et {
                // Date
                let date = Date(timeIntervalSinceReferenceDate: t)
                /// Go through planet Nodes and cycle their motion state
                for planetNodeType in planetNodeTypes {
                    /// Detector
                    let detector = detectors[planetNodeType] ?? RetrogradeDetector()
                    /// Cycle the Detector to get a Motion State
                    let motionState:PlanetNodeState.MotionState? = detector.cycleMotionState(planetNodeType: planetNodeType,
                                                                                             date: date)
                    /// Get Previous Motion State
                    guard let previousMotionState = previousMotionStates[planetNodeType] else {
                        /// Set Previous if None found
                        previousMotionStates[planetNodeType] = motionState
                        continue
                    }
                    
                    /// Test Motion State
                    let pMotion = previousMotionState.motion
                    let motion = motionState!.motion
                    
                    // Detect Motion Change
                    if pMotion != motion {
                        if self.useDeepScan {
                            /// Binary Search Tree
                            self.deepScanner.deepScan(motion: pMotion,
                                                      changedTo: motion,
                                                      planetNodeType: planetNodeType,
                                                      startDate: Date(timeIntervalSinceReferenceDate: t-td),
                                                      endDate: Date(timeIntervalSinceReferenceDate: t+td))
                        } else {
                            /// Add Retrograde Event
                            let retrogradeEvent = CoreAstrology.RetrogradeEvent(date: date,
                                                                                planetNodeType: planetNodeType,
                                                                                retrogradeType: motion)
                            var eventList = results[planetNodeType] ?? [:]
                            eventList[date] = retrogradeEvent
                            results[planetNodeType] = eventList
                        }
                    }
                    
                    /// Set Previous
                    previousMotionStates[planetNodeType] = motionState
                }
                
                /// Iterate upward Time(t) by TimeDelta(td)
                t += td
            }
            return results
        }
    }
}


extension CelestialEventScanner.RetrogradeEventScanner {
    // RetrogradeEvent Scan Results
    typealias ScanResults = [PlanetNodeType:[Date:CoreAstrology.RetrogradeEvent]]
}

extension CelestialEventScanner.RetrogradeEventScanner.ScanResults {
    
}

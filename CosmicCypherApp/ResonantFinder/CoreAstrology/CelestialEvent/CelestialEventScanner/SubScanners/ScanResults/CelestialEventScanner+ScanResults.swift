//
//  CelestialEventScanner+ScanResults.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/28/23.
//

import Foundation

// MARK: ScanResults
extension CelestialEventScanner {
    // Scan Results
    class SubScanResults {
        /// Events
        var events:[CoreAstrology.CelestialEventType:[CoreAstrology.CelestialEvent]] = [:]
        /// Add
        func add(event:CoreAstrology.CelestialEvent) {
            if var typeEvents = self.events[event.type] {
                typeEvents.append(event)
                self.events[event.type] = typeEvents
            } else {
                self.events[event.type] = [event]
            }
        }
        
        func add(retrogradeScanResults:RetrogradeEventScanner.ScanResults) {
            
        }
        
        func convert() -> CelestialEventScanner.Results {
            var results = CelestialEventScanner.Results()
            return results
        }
    }
    
    // MARK: Sub Scanner Results Handlers
    // Handle Retrograde Scan Results
    func handleRetrograde(scanResults: RetrogradeEventScanner.ScanResults?) {
        //self.scanResults.add(event: <#T##CoreAstrology.CelestialEvent#>)
    }
    // Handle Retrograde Scan Results
    func handleRetrograde(scanResults: TransitEventScanner.ScanResults?) {
        
    }
    // Handle Retrograde Scan Results
    func handleRetrograde(scanResults: AspectEventScanner.ScanResults?) {
        
    }
    // Handle Retrograde Scan Results
    func handleRetrograde(scanResults: FormationEventScanner.ScanResults?) {
        
    }
    // Handle Retrograde Scan Results
    func handleRetrograde(scanResults: OctiveEventScanner.ScanResults?) {
        
    }
    // Handle Retrograde Scan Results
    func handleRetrograde(scanResults: ResonanceEventScanner.ScanResults?) {
        
    }
}

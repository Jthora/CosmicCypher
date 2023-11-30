//
//  CelestialEventScanner+ResonanceEventScanner.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/26/23.
//

import Foundation

// MARK: Resonance Scanner
extension CelestialEventScanner {
    // Resonance Scanner
    class ResonanceEventScanner: SubScanner {
        var detector = ResonanceDetector()
        public var useDeepScan: Bool = true
    }
}

extension CelestialEventScanner.ResonanceEventScanner {
    // RetrogradeEvent Scan Results
    typealias ScanResults = [PlanetNodeType:[Date:CoreAstrology.ResonanceEvent]]
}

extension CelestialEventScanner.ResonanceEventScanner.ScanResults {
    
}

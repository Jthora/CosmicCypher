//
//  CelestialEventScanner+OctiveEventScanner.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/26/23.
//

import Foundation

// MARK: Octive Event Scanner
extension CelestialEventScanner {
    // Octive Event Scanner
    class OctiveEventScanner: SubScanner {
        var detector = OctiveDetector()
        public var useDeepScan: Bool = true
    }
}

extension CelestialEventScanner.OctiveEventScanner {
    // RetrogradeEvent Scan Results
    typealias ScanResults = [PlanetNodeType:[Date:CoreAstrology.OctiveEvent]]
}

extension CelestialEventScanner.OctiveEventScanner.ScanResults {
    
}

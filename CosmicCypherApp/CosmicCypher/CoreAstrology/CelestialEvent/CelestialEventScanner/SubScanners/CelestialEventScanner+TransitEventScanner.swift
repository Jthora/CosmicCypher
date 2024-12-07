//
//  CelestialEventScanner+TransitEventScanner.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/26/23.
//

import Foundation

// MARK: Transit Scanner
extension CelestialEventScanner {
    // Transit Scanner
    class TransitEventScanner: SubScanner {
        var detector = TransitDetector()
        public var useDeepScan: Bool = true
    }
}

extension CelestialEventScanner.TransitEventScanner {
    // RetrogradeEvent Scan Results
    typealias ScanResults = [PlanetNodeType:[Date:CoreAstrology.TransitEvent]]
}

extension CelestialEventScanner.TransitEventScanner.ScanResults {
    
}

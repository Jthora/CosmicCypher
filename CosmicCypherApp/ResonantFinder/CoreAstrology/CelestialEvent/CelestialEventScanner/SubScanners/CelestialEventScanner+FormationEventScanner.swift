//
//  CelestialEventScanner+FormationEventScanner.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/26/23.
//

import Foundation

// MARK: Formation Scanner
extension CelestialEventScanner {
    // Formation Scanner
    class FormationEventScanner: SubScanner {
        var detector = FormationDetector()
        public var useDeepScan: Bool = true
    }
}

extension CelestialEventScanner.FormationEventScanner {
    // RetrogradeEvent Scan Results
    typealias ScanResults = [PlanetNodeType:[Date:CoreAstrology.FormationEvent]]
}

extension CelestialEventScanner.FormationEventScanner.ScanResults {
    
}

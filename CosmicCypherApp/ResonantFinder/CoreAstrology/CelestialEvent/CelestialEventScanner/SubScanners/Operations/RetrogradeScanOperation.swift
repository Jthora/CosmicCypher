//
//  RetrogradeScanOperation.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/26/23.
//

import Foundation

// MARK: Retrograde Scan Operation
class RetrogradeScanOperation: Operation {
    // References
    var mainScanner:CelestialEventScanner? = nil
    var scanner:CelestialEventScanner.RetrogradeEventScanner? = nil
    // MARK: Operation Main Function
    override func main() {
        // Scan
        let results = scanner?.scan(startDate: CelestialEventScanner.Core.startDate,
                                    endDate: CelestialEventScanner.Core.endDate,
                                    planetNodeTypes: CelestialEventScanner.Core.planetsAndNodes)
        // Callbacks
        mainScanner?.handleRetrograde(scanResults: results)
    }
}


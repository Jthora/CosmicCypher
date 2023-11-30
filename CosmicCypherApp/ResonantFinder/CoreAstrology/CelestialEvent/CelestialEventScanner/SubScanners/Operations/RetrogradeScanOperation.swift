//
//  RetrogradeScanOperation.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/26/23.
//

import Foundation

class RetrogradeScanOperation: Operation {
    var mainScanner:CelestialEventScanner? = nil
    var scanner:CelestialEventScanner.RetrogradeEventScanner? = nil
    override func main() {
        // Implement retrograde scanning logic]
        let results = scanner?.scan(startDate: CelestialEventScanner.Core.startDate,
                                    endDate: CelestialEventScanner.Core.endDate,
                                    planetNodeTypes: CelestialEventScanner.Core.planetsAndNodes)
        mainScanner?.handleRetrograde(scanResults: results)
    }
}


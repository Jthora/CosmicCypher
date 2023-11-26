//
//  CelestialEventScanner+Archive.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/7/23.
//

import Foundation


extension CelestialEventScanner {
    

    // Archive the currently Locked In Aspects
    func archiveResults(aspectsFound:[Date: [CoreAstrology.Aspect]]) {
        // Archiving Results
        //print("Archiving Results")
        let hashKey = Results.HashKey(startDate: self.startDate,
                                      endDate: self.endDate,
                                      longitude: self.longitude,
                                      latitude: self.latitude)
        let results = Results(lockedInAspects: aspectsFound, hashKey: hashKey)
        self.archive(results: results)
    }
}

//
//  AspectEventDataArchive.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/30/23.
//

import Foundation

class AspectEventDataArchive {
    
    var cache:[AspectEventScanner.Results.HashKey:AspectEventScanner.Results] = [:]
    var latestHashKey:AspectEventScanner.Results.HashKey? = nil
    
    func store(results:AspectEventScanner.Results) {
        cache[results.hashKey] = results
        latestHashKey = results.hashKey
    }
    
    func fetch(for hashKey:AspectEventScanner.Results.HashKey) -> AspectEventScanner.Results? {
        // Async extract data persistantly
        return cache[hashKey]
    }
}

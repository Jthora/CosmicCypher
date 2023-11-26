//
//  CelestialEventScanner+TransitDetector.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/25/23.
//

import Foundation
import SwiftAA

// MARK: Transit Detector
extension CelestialEventScanner {
    // Transit Detector
    /// Detects Phase Changes in base 12, 24 and 36 (Zodiac, Cusps and Decans)
    class TransitDetector {
        
        // MARK: Properties
        // Vector Memory for Transit Change Detection
        var previousZodiac:Arcana.Zodiac? = nil
        var previousCusp:Arcana.Cusp? = nil
        var previousDecan:Arcana.Decan? = nil
        
        // MARK: Methods
        // Get Transit Events
        func cycle(planetNode:PlanetNode) -> Results {
            // Results
            var results:Results = Results()
            
            // Previous Phase Values
            guard let previousZodiac = previousZodiac,
                   let previousCusp = previousCusp,
                   let previousDecan = previousDecan else {
                /// initialize
                previousZodiac = Arcana.Zodiac.from(degree: planetNode.longitude)
                previousCusp = Arcana.Cusp.from(degree: planetNode.longitude)
                previousDecan = Arcana.Decan.from(degree: planetNode.longitude)
                /// Return empty results
                return results
            }
            
            // Current Phase Values
            let zodiac = Arcana.Zodiac.from(degree: planetNode.longitude)
            let cusp = Arcana.Cusp.from(degree: planetNode.longitude)
            let decan = Arcana.Decan.from(degree: planetNode.longitude)
            
            // Zodiac Changed
            if zodiac != previousZodiac {
                results.add(transit: .zodiac(zodiac), [planetNode])
            }
            // Cusp Changed
            if cusp != previousCusp {
                results.add(transit: .cusps(cusp), [planetNode])
            }
            // Decan Changed
            if decan != previousDecan {
                results.add(transit: .decans(decan), [planetNode])
            }
            
            // Reset Previous
            self.previousZodiac = zodiac
            self.previousCusp = cusp
            self.previousDecan = decan
            
            return results
        }
    }
}

// MARK: Transit Detector Results
extension CelestialEventScanner.TransitDetector {
    // Detector Results
    struct Results {
        var transits: [CoreAstrology.TransitEvent.TransitType: [PlanetNode]] = [:]
        // Merge function
        mutating func merge(with other: Results) {
            for (transitType, planetNodes) in other.transits {
                transits[transitType, default: []].append(contentsOf: planetNodes)
            }
        }
        // Function to retrieve formations of a specific type
        func formations(ofType type: CoreAstrology.TransitEvent.TransitType) -> [PlanetNode]? {
            return transits[type]
        }
        // Function to filter formations based on a condition
        func filterFormations(by filter: (CoreAstrology.TransitEvent.TransitType, [PlanetNode]) -> Bool) -> [CoreAstrology.TransitEvent.TransitType: [PlanetNode]] {
            var filteredTransits: [CoreAstrology.TransitEvent.TransitType: [PlanetNode]] = [:]
            for (transitType, planetNodes) in transits {
                if filter(transitType, planetNodes) {
                    filteredTransits[transitType] = planetNodes
                }
            }
            return filteredTransits
        }
        // Add Transit
        mutating func add(transit: CoreAstrology.TransitEvent.TransitType, _ planetNodes: [PlanetNode]) {
            transits[transit, default: []].append(contentsOf: planetNodes)
        }
    }
}

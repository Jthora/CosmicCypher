//
//  CelestialEventScanner+AstrologicalFormationDetector.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/24/23.
//

import Foundation
import SwiftAA

// MARK: Formation Detector
extension CelestialEventScanner {
    // Astrological Formation Detector
    class FormationDetector {
        
        
        func cycleMotionState(for planetNodeType:PlanetNodeType, timeInterval:TimeInterval) -> CoreAstrology.FormationEvent? {
            return nil
        }
    }
}

// MARK: Formation Detector Results
extension CelestialEventScanner.FormationDetector {
    // Detector Results
    struct Results {
        var formations: [CoreAstrology.FormationEvent.FormationType: [PlanetNode]] = [:]
        // Merge function
        mutating func merge(with other: Results) {
            for (formationType, planetNodes) in other.formations {
                formations[formationType, default: []].append(contentsOf: planetNodes)
            }
        }
        // Function to retrieve formations of a specific type
        func formations(ofType type: CoreAstrology.FormationEvent.FormationType) -> [PlanetNode]? {
            return formations[type]
        }
        // Function to filter formations based on a condition
        func filterFormations(by filter: (CoreAstrology.FormationEvent.FormationType, [PlanetNode]) -> Bool) -> [CoreAstrology.FormationEvent.FormationType: [PlanetNode]] {
            var filteredFormations: [CoreAstrology.FormationEvent.FormationType: [PlanetNode]] = [:]
            for (formationType, planetNodes) in formations {
                if filter(formationType, planetNodes) {
                    filteredFormations[formationType] = planetNodes
                }
            }
            return filteredFormations
        }
        mutating func add(formation: CoreAstrology.FormationEvent.FormationType, _ planetNodes: [PlanetNode]) {
            formations[formation, default: []].append(contentsOf: planetNodes)
        }
    }
}

// MARK: Formation Detection
extension CelestialEventScanner.FormationDetector {
    // Detect for any and all of the major Astrological Formations
    func detect(for planetNodes: [PlanetNode]) -> Results {
        return detect(formations: CoreAstrology.FormationEvent.FormationType.allCases, for: planetNodes)
    }
    
    // Detect a Group
    func detect(formations:[CoreAstrology.FormationEvent.FormationType], for planetNodes: [PlanetNode]) -> Results {
        var results = Results()
        for formation in formations {
            results.merge(with: detect(formation: formation, for: planetNodes))
        }
        return results
    }
    
    // Detect Specific
    func detect(formation:CoreAstrology.FormationEvent.FormationType, for planetNodes: [PlanetNode]) -> Results {
        switch formation {
        case .grandTrine:
            return detectGrandTrine(planetNodes)
        case .mysticRectangle:
            return detectMysticRectangle(planetNodes)
        case .kite:
            return detectKite(planetNodes)
        case .tSquare:
            return detectTSquare(planetNodes)
        case .stellium:
            return detectStellium(planetNodes)
        case .yod:
            return detectYod(planetNodes)
        case .mysticCross:
            return detectMysticCross(planetNodes)
        case .grandSextile:
            return detectGrandSextile(planetNodes)
        }
    }
}

// MARK: Detection Funcitons
extension CelestialEventScanner.FormationDetector {
    // Functions to detect each formation
    
    func detectGrandTrine(_ planetNodes: [PlanetNode]) -> Results {
        // Logic to detect a grand trine formation
        return detectMultipleGrandTrines(planetNodes) // Placeholder
    }
    
    func detectMysticRectangle(_ planetNodes: [PlanetNode]) -> Results {
        // Logic to detect a mystic rectangle formation
        let degrees = planetNodes.map { $0.longitude }
        detectMultipleMysticRectangles(degrees)
        return Results() // Placeholder
    }
    
    func detectKite(_ planetNodes: [PlanetNode]) -> Results {
        // Logic to detect a kite formation
        return Results() // Placeholder
    }
    
    func detectTSquare(_ planetNodes: [PlanetNode]) -> Results {
        // Logic to detect a T-square formation
        return Results() // Placeholder
    }
    
    func detectStellium(_ planetNodes: [PlanetNode]) -> Results {
        // Logic to detect a stellium formation
        return Results() // Placeholder
    }
    
    func detectYod(_ planetNodes: [PlanetNode]) -> Results {
        // Logic to detect a Yod formation
        return Results() // Placeholder
    }
    
    func detectMysticCross(_ planetNodes: [PlanetNode]) -> Results {
        // Logic to detect a mystic cross formation
        return Results() // Placeholder
    }
    
    func detectGrandSextile(_ planetNodes: [PlanetNode]) -> Results {
        // Logic to detect a grand sextile formation
        return Results() // Placeholder
    }
}

// MARK: Detect Triangles
extension CelestialEventScanner.FormationDetector {
    // Detect Multiple Grand Trines
    func detectMultipleGrandTrines(_ planetNodes: [PlanetNode]) -> Results {
        var results:Results = Results()
        guard planetNodes.count >= 3 else { return results }
        let count = planetNodes.count

        var countGrandTriangles = 0
        let sortedPlanetNodes = planetNodes.sorted { p1, p2 in
            return p1.longitude < p2.longitude
        }

        for i in 0..<(count - 2) {
            var k = i + 2

            for j in (i + 1)..<(count - 1) {
                while k < count && sortedPlanetNodes[i].longitude.value + 120 > sortedPlanetNodes[k].longitude.value {
                    k += 1
                }
                
                if k < count && sortedPlanetNodes[i].longitude.value + 120 == sortedPlanetNodes[k].longitude.value {
                    results.add(formation: .grandTrine, [sortedPlanetNodes[i], sortedPlanetNodes[j], sortedPlanetNodes[k]])
                }
            }
        }

        return results
    }
}

// MARK: Detect Yod Formation Event
extension CelestialEventScanner.FormationDetector {
    // Detect Yod
    func detectYod(_ degrees: [Degree]) -> Bool {
        guard degrees.count == 3 else { return false }

        let sortedDegrees = degrees.map { $0.value }.sorted()

        let diff1 = sortedDegrees[1] - sortedDegrees[0]
        let diff2 = sortedDegrees[2] - sortedDegrees[1]
        let diff3 = 360 - sortedDegrees[2] + sortedDegrees[0]

        let epsilon = 5.0 // Adjust the epsilon value as needed for tolerance
        return (abs(diff1 - 150) < epsilon && abs(diff2 - 150) < epsilon) ||
               (abs(diff1 - 150) < epsilon && abs(diff3 - 150) < epsilon) ||
               (abs(diff2 - 150) < epsilon && abs(diff3 - 150) < epsilon)
    }
    // Detect Multiple Yods
    func detectMultipleYods(_ degrees: [Degree]) -> Int {
        guard degrees.count >= 3 else { return 0 }
        // Yod Count
        var countYods = 0
        let sortedDegrees = degrees.map { $0.value }.sorted()

        for i in 0..<(degrees.count - 2) {
            var k = i + 2

            for j in (i + 1)..<(degrees.count - 1) {
                while k < degrees.count && sortedDegrees[i] + 150 > sortedDegrees[k] {
                    k += 1
                }

                if k < degrees.count && sortedDegrees[i] + 150 == sortedDegrees[k] {
                    countYods += degrees.count - k
                }
            }
        }
        return countYods
    }
}

// MARK: Detect Mystic Rectangle Formation Event
extension CelestialEventScanner.FormationDetector {
    // Detect Mystic Rectangle
    func detectMysticRectangle(_ degrees: [Degree]) -> Bool {
        guard degrees.count == 4 else { return false }

        let sortedDegrees = degrees.map { $0.value }.sorted()

        let diff1 = abs(sortedDegrees[1] - sortedDegrees[0])
        let diff2 = abs(sortedDegrees[2] - sortedDegrees[1])
        let diff3 = abs(sortedDegrees[3] - sortedDegrees[2])
        let diff4 = 360 - abs(sortedDegrees[3] - sortedDegrees[0])

        let epsilon = 5.0 // Adjust the epsilon value as needed for tolerance
        return (abs(diff1 - 180) < epsilon && abs(diff3 - 180) < epsilon) &&
               (abs(diff2 - 120) < epsilon && abs(diff4 - 120) < epsilon)
    }

    // Detect Multiple Mystic Rectangles
    func detectMultipleMysticRectangles(_ degrees: [Degree]) -> Int {
        guard degrees.count >= 4 else { return 0 }
        var countMysticRectangles = 0
        let sortedDegrees = degrees.map { $0.value }.sorted()
        for i in 0..<(degrees.count - 3) {
            var k = i + 3
            for j in (i + 1)..<(degrees.count - 2) {
                while k < degrees.count && sortedDegrees[i] + 180 > sortedDegrees[k] {
                    k += 1
                }

                if k < degrees.count && sortedDegrees[i] + 180 == sortedDegrees[k] {
                    countMysticRectangles += degrees.count - k
                }
            }
        }
        return countMysticRectangles
    }
}

// MARK: Detect Kite
extension CelestialEventScanner.FormationDetector {
    // Detect Kite Formation
    func detectKite(_ degrees: [Degree]) -> Bool {
        guard degrees.count == 4 else { return false }
        let sortedDegrees = degrees.map { $0.value }.sorted()
        let diff1 = abs(sortedDegrees[1] - sortedDegrees[0])
        let diff2 = abs(sortedDegrees[2] - sortedDegrees[0])
        let diff3 = abs(sortedDegrees[3] - sortedDegrees[0])
        let epsilon = 5.0 // Adjust the epsilon value as needed for tolerance
        return (diff1 == 180 || diff2 == 180 || diff3 == 180)
               && (diff1 == 120 || diff2 == 120 || diff3 == 120)
               && (diff1 == 120 || diff2 == 120 || diff3 == 120)
    }
    // Detect Multiple Kite Formations
    func detectMultipleKites(_ degrees: [Degree]) -> Int {
        guard degrees.count >= 4 else { return 0 }
        var countKites = 0
        let sortedDegrees = degrees.map { $0.value }.sorted()
        for i in 0..<(degrees.count - 3) {
            var k = i + 3
            for j in (i + 1)..<(degrees.count - 2) {
                while k < degrees.count && sortedDegrees[k] - sortedDegrees[i] < 180 {
                    k += 1
                }
                if k < degrees.count && (sortedDegrees[k] - sortedDegrees[i] == 180) {
                    countKites += degrees.count - k
                }
            }
        }
        return countKites
    }
}

// MARK: Detect T-Square
extension CelestialEventScanner.FormationDetector {
    // Detect T-Square
    func detectTSquare(_ degrees: [Degree]) -> Bool {
        guard degrees.count == 3 else { return false }
        let sortedDegrees = degrees.map { $0.value }.sorted()
        let diff1 = abs(sortedDegrees[1] - sortedDegrees[0])
        let diff2 = abs(sortedDegrees[2] - sortedDegrees[1])
        let diff3 = abs(360 - sortedDegrees[2] + sortedDegrees[0])
        let epsilon = 5.0 // Adjust the epsilon value as needed for tolerance
        return (diff1 == 90 && diff2 == 90 && diff3 == 180) ||
               (diff1 == 90 && diff2 == 180 && diff3 == 90) ||
               (diff1 == 180 && diff2 == 90 && diff3 == 90)
    }
    // Detect Multiple T-Squares
    func detectMultipleTSquares(_ degrees: [Degree]) -> Int {
        guard degrees.count >= 3 else { return 0 }
        var countTSquares = 0
        let sortedDegrees = degrees.map { $0.value }.sorted()
        for i in 0..<(degrees.count - 2) {
            var k = i + 2
            for j in (i + 1)..<(degrees.count - 1) {
                while k < degrees.count && sortedDegrees[i] + 90 > sortedDegrees[k] {
                    k += 1
                }
                if k < degrees.count && sortedDegrees[i] + 90 == sortedDegrees[k] {
                    countTSquares += degrees.count - k
                }
            }
        }
        return countTSquares
    }
}

// MAARK: Detect Stellium
extension CelestialEventScanner.FormationDetector {
    // Detect Stellium
    func detectStellium(_ degrees: [Degree]) -> Bool {
        // Define the threshold for a stellium
        let stelliumThreshold = 8.0 // Adjust as needed based on astrological considerations
        guard degrees.count >= 3 else { return false }
        let sortedDegrees = degrees.map { $0.value }.sorted()
        // Check if the degrees are clustered within a small span
        let span = sortedDegrees.last! - sortedDegrees.first!
        return span <= stelliumThreshold
    }
    // Detect Multiple Stelliums
    func detectMultipleStelliums(_ degrees: [Degree]) -> Int {
        guard degrees.count >= 3 else { return 0 }
        var countStelliums = 0
        let sortedDegrees = degrees.map { $0.value }.sorted()
        for i in 0..<(degrees.count - 2) {
            let span = sortedDegrees[i + 2] - sortedDegrees[i]
            if span <= 8.0 { // Adjust the threshold as needed
                countStelliums += 1
            }
        }
        return countStelliums
    }
}

// MARK: Detect Mystic Cross
extension CelestialEventScanner.FormationDetector {
    // Detect Mystic Cross
    func detectMysticCross(_ degrees: [Degree]) -> Bool {
        guard degrees.count == 4 else { return false }
        let sortedDegrees = degrees.map { $0.value }.sorted()
        let diff1 = abs(sortedDegrees[1] - sortedDegrees[0])
        let diff2 = abs(sortedDegrees[2] - sortedDegrees[1])
        let diff3 = abs(sortedDegrees[3] - sortedDegrees[2])
        let diff4 = 360 - sortedDegrees[3] + sortedDegrees[0]
        let epsilon = 5.0 // Adjust the epsilon value as needed for tolerance
        return (abs(diff1 - 90) < epsilon && abs(diff2 - 90) < epsilon &&
                abs(diff3 - 90) < epsilon && abs(diff4 - 180) < epsilon)
    }
    // Detect Multiple Mystic Crosses
    func detectMultipleMysticCrosses(_ degrees: [Degree]) -> Int {
        guard degrees.count >= 4 else { return 0 }
        var countMysticCrosses = 0
        let sortedDegrees = degrees.map { $0.value }.sorted()
        for i in 0..<(degrees.count - 3) {
            var k = i + 3
            for j in (i + 1)..<(degrees.count - 2) {
                for l in (j + 1)..<(degrees.count - 1) {
                    while k < degrees.count && sortedDegrees[i] + 180 > sortedDegrees[k] {
                        k += 1
                    }
                    if k < degrees.count && sortedDegrees[i] + 180 == sortedDegrees[k] {
                        countMysticCrosses += degrees.count - k
                    }
                }
            }
        }
        return countMysticCrosses
    }
}

// MARK: Detect Grand Sextile
extension CelestialEventScanner.FormationDetector {
    // Detect Grand Sextile
    func detectGrandSextile(_ degrees: [Degree]) -> Bool {
        guard degrees.count == 6 else { return false }
        let sortedDegrees = degrees.map { $0.value }.sorted()
        let diff1 = sortedDegrees[1] - sortedDegrees[0]
        let diff2 = sortedDegrees[2] - sortedDegrees[1]
        let diff3 = sortedDegrees[3] - sortedDegrees[2]
        let diff4 = sortedDegrees[4] - sortedDegrees[3]
        let diff5 = sortedDegrees[5] - sortedDegrees[4]
        let diff6 = 360 - sortedDegrees[5] + sortedDegrees[0]
        let epsilon = 5.0 // Adjust the epsilon value as needed for tolerance
        return abs(diff1 - 60) < epsilon &&
               abs(diff2 - 60) < epsilon &&
               abs(diff3 - 60) < epsilon &&
               abs(diff4 - 60) < epsilon &&
               abs(diff5 - 60) < epsilon &&
               abs(diff6 - 60) < epsilon
    }
    // Detect Multiple Grand Sextiles
    func detectMultipleGrandSextiles(_ degrees: [Degree]) -> Int {
        guard degrees.count >= 6 else { return 0 }
        var countGrandSextiles = 0
        let sortedDegrees = degrees.map { $0.value }.sorted()
        for i in 0..<(degrees.count - 5) {
            var k = i + 5
            for j in (i + 1)..<(degrees.count - 4) {
                while k < degrees.count && sortedDegrees[i] + 60 > sortedDegrees[k] {
                    k += 1
                }
                if k < degrees.count && sortedDegrees[i] + 60 == sortedDegrees[k] {
                    countGrandSextiles += degrees.count - k
                }
            }
        }
        return countGrandSextiles
    }
}

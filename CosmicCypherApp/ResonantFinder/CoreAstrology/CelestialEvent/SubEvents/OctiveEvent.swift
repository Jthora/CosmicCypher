//
//  ShapeEvent.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/23/23.
//

import Foundation
import SwiftAA

// MARK: Harmonic Event
extension CoreAstrology {
    // Harmonic Event
    public class OctiveEvent: CelestialEvent {
        var octiveType:OctiveType
        override var type: CoreAstrology.CelestialEventType {
            return .octive(octiveType)
        }
        // Geometric Type
        enum OctiveType: Int, CaseIterable {
            case triangle // Sum of angles = 180 degrees
            case square // Sum of angles = 360 degrees
            case pentagon // Sum of angles = 540 degrees
            case hexagon // Sum of angles = 720 degrees
            case heptagon // Sum of angles = 900 degrees
            case octagon // Sum of angles = 1080 degrees
            case nonagon // Sum of angles = 1260 degrees
            case decagon // Sum of angles = 1440 degrees
            case hendecagon // Sum of angles = 1620 degrees
            case dodecagon // Sum of angles = 1800 degrees
            
            var numberOfSides: Int {
                switch self {
                case .triangle: return 3
                case .square: return 4
                case .pentagon: return 5
                case .hexagon: return 6
                case .heptagon: return 7
                case .octagon: return 8
                case .nonagon: return 9
                case .decagon: return 10
                case .hendecagon: return 11
                case .dodecagon: return 12
                }
            }
            
            var sumOfAngles: Degree {
                switch self {
                case .triangle: return 180
                case .square: return 360
                case .pentagon: return 540
                case .hexagon: return 720
                case .heptagon: return 900
                case .octagon: return 1080
                case .nonagon: return 1260
                case .decagon: return 1440
                case .hendecagon: return 1620
                case .dodecagon: return 1800
                }
            }
            
            func testAngles(_ angles: [Degree], withOrb orb: Degree) -> Bool {
                let expectedSum = self.sumOfAngles
                guard !angles.isEmpty else { return false } // Handle empty angle array
                
                let sumOfAngles = angles.reduce(0, +)
                let lowerBound = expectedSum - abs(orb)
                let upperBound = expectedSum + abs(orb)
                
                // Normalize angles to fit within the expected sum of angles ± orb
                let normalizedSum = abs(sumOfAngles - expectedSum)
                return normalizedSum <= abs(orb)
            }
        }
        
        init(startDate: Date? = nil, endDate: Date? = nil, date: Date, planetNodeTypes: [PlanetNodeType], octiveType: OctiveType) {
            self.octiveType = octiveType
            super.init(startDate: startDate, endDate: endDate, date: date, planetNodeTypes: planetNodeTypes)
        }
    }
}


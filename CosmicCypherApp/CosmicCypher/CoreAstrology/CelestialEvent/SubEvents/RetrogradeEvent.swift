//
//  RetrogradeEvent.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/23/23.
//

import Foundation

// MARK: Celestial Event
extension CoreAstrology {
    // Retrograde Event
    public class RetrogradeEvent: CelestialEvent {
        var retrogradeType:RetrogradeType
        override var type: CoreAstrology.CelestialEventType {
            return .retrograde(retrogradeType)
        }
        var planetNodeType: PlanetNodeType {
            return planetNodeTypes.first!
        }
        // MARK: Init
        init(startDate: Date? = nil, endDate: Date? = nil, date: Date, planetNodeType: PlanetNodeType, retrogradeType: RetrogradeType) {
            self.retrogradeType = retrogradeType
            super.init(startDate: startDate, endDate: endDate, date: date, planetNodeTypes: [planetNodeType])
        }
        
        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }
    }
}

extension CoreAstrology.RetrogradeEvent {
    typealias RetrogradeType = PlanetNodeState.MotionState.Motion
}

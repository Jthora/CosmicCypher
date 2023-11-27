//
//  ResonanceEvent.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/26/23.
//

import Foundation

// MARK: Resonance Event
extension CoreAstrology {
    // Resonance Event
    public class ResonanceEvent: CelestialEvent {
        // MARK: Type
        var resonanceEventType: ResonanceEventType
        override var type: CoreAstrology.CelestialEventType {
            return .resonance(resonanceEventType)
        }
        
        // MARK: Init
        init(startDate: Date? = nil, endDate: Date? = nil, date: Date, resonanceEventType: ResonanceEventType, planetNodeTypes:[PlanetNodeType]) {
            self.resonanceEventType = resonanceEventType
            super.init(startDate: startDate, endDate: endDate, date: date, planetNodeTypes: planetNodeTypes)
        }
    }
}

// MARK: Resonance Event Type
extension CoreAstrology {
    enum ResonanceEventType:Hashable {
        //case gravimetric(_ focalPoint: FocalPoint) // Global Net Energy (Solar Net Energy, Unified Net Energy)
        //case alignment(_ focalPoint: FocalPoint) // Global Energy Alignment (Solar Energy Alignment, Unified Energy Alignment)
        case harmonics(_ focalPoint: FocalPoint) // Global Frequency Harmonics (Solar Frequency Harmonics, Unified Frequency Harmonics)
        
        enum FocalPoint:Int, CaseIterable {
            case global // Geocentric
            case solar // Heliocentric
            case unified // Interplanetary
        }
    }
    
    enum ResonanceEventSubType {
        case peak // exa
        case drop // fall
        case base // deb
        case rise // rise
    }
}

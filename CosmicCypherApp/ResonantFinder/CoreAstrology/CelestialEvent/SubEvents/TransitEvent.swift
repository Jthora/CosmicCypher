//
//  TransitEvent.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/26/23.
//

import Foundation

// MARK: Transit Event
extension CoreAstrology {
    // Transit Event
    public class TransitEvent: CelestialEvent {
        // MARK: Properties
        var transitType:TransitType
        override var type: CoreAstrology.CelestialEventType {
            return .transit(transitType)
        }
        
        // MARK: init
        init(date: Date, transitType: TransitType, planetNode:PlanetNode) {
            self.transitType = transitType
            super.init(date: date, planetNodeTypes: [planetNode.nodeType])
        }
        
    }
}
    
// MARK: Transit Event
extension CoreAstrology.TransitEvent {
    // Transit Event Type
    enum TransitType: Hashable {
        case zodiac(_ zodiac:Arcana.Zodiac)
        case cusps(_ cusp:Arcana.Cusp)
        case decans(_ decan:Arcana.Decan)
        case house(_ house:Arcana.House)
    }
}

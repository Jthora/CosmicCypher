//
//  CelestialEvent.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/20/23.
//

import Foundation
import SwiftAA

// MARK: Celestial Event
extension CoreAstrology {
    // Celestial Event
    typealias CelestialEventSequence = [CelestialEvent]
    
    
    // Celestial Event
   public class CelestialEvent {
       let date: Date
       let startDate: Date?
       let endDate: Date?
       var planetNodeTypes: [PlanetNodeType]
       var type:CelestialEventType {
           fatalError("Subclasses must override this method")
       }

       init(startDate: Date? = nil, endDate: Date? = nil, date: Date, planetNodeTypes: [PlanetNodeType]) {
           self.startDate = startDate
           self.endDate = endDate
           self.date = date
           self.planetNodeTypes = planetNodeTypes
       }
   }
}

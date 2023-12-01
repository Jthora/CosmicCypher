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
    public class CelestialEvent: Codable {
       let date: Date
       let startDate: Date?
       let endDate: Date?
       var planetNodeTypes: [PlanetNodeType]
       
       // Required
       /// Type
       var type:CelestialEventType {
           fatalError("Subclasses must override this method")
       }
       

       init(startDate: Date? = nil, endDate: Date? = nil, date: Date, planetNodeTypes: [PlanetNodeType]) {
           self.startDate = startDate
           self.endDate = endDate
           self.date = date
           self.planetNodeTypes = planetNodeTypes
       }
       
       var json:Data? {
           do {
               let jsonDate = try JSONEncoder().encode(date)
               let jsonStartDate = try JSONEncoder().encode(startDate)
               let jsonEndDate = try JSONEncoder().encode(endDate)
               let jsonPlanetNodeTypes = try JSONEncoder().encode(planetNodeTypes)
               let jsonType = try JSONEncoder().encode(type)
               
               var data:Data = Data()
               data.append(jsonDate)
               data.append(jsonStartDate)
               data.append(jsonEndDate)
               data.append(jsonPlanetNodeTypes)
               data.append(jsonType)
               
               return data
           } catch {
               print("ERROR:\(error)")
           }
           return nil
       }
   }
}

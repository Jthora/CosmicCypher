//
//  AspectEvent.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/23/23.
//

import Foundation

// MARK: Aspect Event
extension CoreAstrology {
    // Aspect Event
    public class AspectEvent: CelestialEvent {
        // Aspect Event
        var aspect: Aspect
        override var type: CoreAstrology.CelestialEventType {
            return .aspect(aspect.relation.type)
        }
        
        // MARK: Init
        init(startDate: Date? = nil, endDate: Date? = nil, date: Date, aspect: Aspect) {
            self.aspect = aspect
            super.init(startDate: startDate, endDate: endDate, date: date, planetNodeTypes: [aspect.primaryBody.type, aspect.secondaryBody.type])
        }
        
        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }
    }
}


// MARK: Type Declaration
extension CoreAstrology {
    typealias AspectEventType = AspectRelationType // It's smarter to just copy what the system already uses, for now...
}

// MARK: Aspect Event Type
extension CoreAstrology.AspectEventType {
    
}

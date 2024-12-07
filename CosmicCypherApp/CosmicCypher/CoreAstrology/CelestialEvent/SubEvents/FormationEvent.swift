//
//  FormationEvent.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/23/23.
//

import Foundation
import SwiftAA

// MARK: Formation Event
extension CoreAstrology {
    // Formation Event
    public class FormationEvent: CelestialEvent {
        // MARK: Type
        var formationType:FormationType
        override var type: CoreAstrology.CelestialEventType {
            return .formation(formationType)
        }
        
        // MARK: Init
        init(date: Date, planetNodeTypes: [PlanetNodeType], formationType: FormationType) {
            self.formationType = formationType
            super.init(date: date, planetNodeTypes: planetNodeTypes)
        }
        
        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }
        
        // MARK: Formation Event Type
        enum FormationType: Int, CaseIterable, Codable {
            case grandTrine
            case mysticRectangle
            case kite
            case tSquare
            case stellium
            case yod
            case mysticCross
            case grandSextile
        }
    }
}

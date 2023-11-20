//
//  AstrologicalNodeType.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/4/22.
//

import Foundation
import SwiftAA

public typealias PlanetNodeType = CoreAstrology.AspectBody.NodeType
public enum PlanetNodeSubType: Int, CaseIterable, Codable {
    case body
    case apogee // .
    case perigee // o
    case ascending // ^
    case decending // u
    case point // +
}

extension PlanetNodeType {
    public var subType: PlanetNodeSubType {
        switch self {
        case .ascendant: return .ascending
        case .decendant: return .decending
        case .midheaven: return .point
        case .imumCoeli: return .point
        case .lunarApogee: return .apogee
        case .lunarPerigee: return .perigee
        case .lunarAscendingNode: return .ascending
        case .lunarDecendingNode: return .decending
        case .sun, .moon, .mercury, .venus, .mars, .jupiter, .saturn, .uranus, .neptune, .pluto: return .body
        case .partOfFortune: return .point
        case .partOfSpirit: return .point
        case .partOfEros: return .point
        }
    }
    
    public func generatePlanetNodeState(date:Date, highPrecision:Bool = true) -> PlanetNodeState? {
        if let planet: Planet = planet(date: date, highPrecision: highPrecision) {
            let planetNodeState = PlanetNodeState(nodeType: self,
                                                  date: date,
                                                  degrees: planet.equatorialCoordinates.alpha.inDegrees.value,
                                                  perihelion: planet.perihelion.value,
                                                  ascendingNode: planet.longitudeOfAscendingNode().value,
                                                  inclination: planet.inclination().value,
                                                  eccentricity: planet.eccentricity(),
                                                  motionState: nil)
            return planetNodeState
        }
        return nil
    }
}

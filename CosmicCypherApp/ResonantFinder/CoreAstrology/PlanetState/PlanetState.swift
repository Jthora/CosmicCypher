//
//  PlanetState.swift
//  StarSeer_Mk2
//
//  Created by Jordan Trana on 9/26/21.
//

import Foundation
//import BinaryCodable
import SwiftAA

public final class PlanetState: AstrologicalNodeState {
    
    public let perihelion: Double
    public let ascendingNode: Double
    public let inclination: Double
    public let eccentricity: Double
    
    public let retrogradeState:PlanetRetrogradeState?
    public let speed:Double?
    
    public var rise:Double {
        return angleDifference(angle1: degrees, angle2: ascendingNode)/180
    }
    
    public var fall:Double {
        return angleDifference(angle1: degrees, angle2: ascendingNode+180)/180
    }
    
    public var exaltation:Double {
        return angleDifference(angle1: degrees, angle2: perihelion)/180
    }
    
    public var debilitation:Double {
        return angleDifference(angle1: degrees, angle2: perihelion+180)/180
    }
    
    public func angleDifference(angle1: Double, angle2: Double ) -> Double {
        let diff: Double = ( angle2 - angle1 + 180.0 ).truncatingRemainder(dividingBy: 360.0) - 180.0
        return diff < -180 ? diff + 360 : diff
    }
    
    
    init?(starChart: StarChart, nodeType: AstrologicalNodeType, retrogradeState:PlanetRetrogradeState? = nil, speed:Double? = nil) {
        
        guard let node = starChart.alignments[nodeType],
              let planet = node.nodeType.planet(starChart: starChart) else { return nil }
        
        self.perihelion = planet.longitudeOfPerihelion().value
        self.ascendingNode = planet.longitudeOfAscendingNode().value
        self.inclination = planet.inclination().value
        self.eccentricity = planet.eccentricity()
        
        self.retrogradeState = retrogradeState
        self.speed = speed
        
        super.init(nodeType: nodeType,
                   subType: .body,
                   date: starChart.date,
                   degrees: node.longitude.value)
    }
    
    init(nodeType:AstrologicalNodeType, date:Date, degrees:Double, perihelion:Double, ascendingNode:Double, inclination:Double, eccentricity:Double, retrogradeState:PlanetRetrogradeState? = nil, speed:Double? = nil) {
        
        self.perihelion = perihelion
        self.ascendingNode = ascendingNode
        self.inclination = inclination
        self.eccentricity = eccentricity
        
        self.retrogradeState = retrogradeState
        self.speed = speed
        
        super.init(nodeType: nodeType,
                   subType: .body,
                   date: date,
                   degrees: degrees)
    }
    
}


extension PlanetState: Codable {
    
    public nonisolated func rawData() throws -> Data { return try JSONEncoder().encode(self) }
    public nonisolated static func from(_ rawData: Data) throws -> PlanetState { return try JSONDecoder().decode(PlanetState.self, from: rawData) }
    
    enum CodingKeys: CodingKey {
        case nodeType
        case date
        case degrees
        
        case perihelion
        case ascendingNode
        case inclination
        case eccentricity
        
        case retrogradeState
        case speed
    }
    
    nonisolated public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(nodeType, forKey: .nodeType)
        try container.encode(date, forKey: .date)
        try container.encode(degrees, forKey: .degrees)
        
        try container.encode(perihelion, forKey: .perihelion)
        try container.encode(ascendingNode, forKey: .ascendingNode)
        try container.encode(inclination, forKey: .inclination)
        try container.encode(eccentricity, forKey: .eccentricity)
        
        try container.encode(retrogradeState, forKey: .retrogradeState)
        try container.encode(speed, forKey: .speed)
    }
    
    public convenience init(from decoder: Decoder) throws {
        //print("decoding PlanetState")
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let nodeType:CoreAstrology.AspectBody.NodeType = try container.decode(CoreAstrology.AspectBody.NodeType.self, forKey: .nodeType)
        let date:Date = try container.decode(Date.self, forKey: .date)
        let degrees:Double = try container.decode(Double.self, forKey: .degrees)
        
        let perihelion:Double = try container.decode(Double.self, forKey: .perihelion)
        let ascendingNode:Double = try container.decode(Double.self, forKey: .ascendingNode)
        let inclination:Double = try container.decode(Double.self, forKey: .inclination)
        let eccentricity:Double = try container.decode(Double.self, forKey: .eccentricity)
        
        let retrogradeState:PlanetRetrogradeState = try container.decode(PlanetRetrogradeState.self, forKey: .retrogradeState)
        let speed:Double = try container.decode(Double.self, forKey: .speed)
        
        self.init(nodeType: nodeType,
                  date: date,
                  degrees: degrees,
                  perihelion: perihelion,
                  ascendingNode: ascendingNode,
                  inclination: inclination,
                  eccentricity: eccentricity,
                  retrogradeState: retrogradeState,
                  speed: speed)
    }
}


extension PlanetState: Hashable {
    
    public nonisolated var hashKey: String { return String(hashValue) }
    
    public static func == (lhs: PlanetState, rhs: PlanetState) -> Bool {
        return lhs.date == rhs.date && lhs.nodeType == rhs.nodeType
    }
    nonisolated public func hash(into hasher: inout Hasher) {
        hasher.combine(nodeType)
        hasher.combine(date)
    }
}

//
//  PlanetNodeState.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/4/22.
//

import Foundation
import SwiftAA

public class PlanetNodeState {
    
    var nodeType:PlanetNodeType
    var date:Date
    var degrees:Double
    
    public var perihelion: Double
    public var ascendingNode: Double
    public var inclination: Double
    public var eccentricity: Double
    
    public var motionState:PlanetNodeState.MotionState?
    
    // MARK: Init
    // init
    init(nodeType: PlanetNodeType,
         date: Date,
         degrees: Double,
         perihelion: Double,
         ascendingNode: Double,
         inclination: Double,
         eccentricity: Double,
         motionState: PlanetNodeState.MotionState?) {
        
        self.nodeType = nodeType
        self.date = date
        self.degrees = degrees
        self.perihelion = perihelion
        self.ascendingNode = ascendingNode
        self.inclination = inclination
        self.eccentricity = eccentricity
        self.motionState = motionState
    }
    
    // required init for Decoder
    public required convenience init(from decoder: Decoder) throws {
        //print("decoding PlanetState")
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let nodeType:PlanetNodeType = try container.decode(PlanetNodeType.self, forKey: .nodeType)
        let date:Date = try container.decode(Date.self, forKey: .date)
        let degrees:Double = try container.decode(Double.self, forKey: .degrees)
        
        let perihelion:Double = try container.decode(Double.self, forKey: .perihelion)
        let ascendingNode:Double = try container.decode(Double.self, forKey: .ascendingNode)
        let inclination:Double = try container.decode(Double.self, forKey: .inclination)
        let eccentricity:Double = try container.decode(Double.self, forKey: .eccentricity)
        
        let motionState:PlanetNodeState.MotionState = try container.decode(PlanetNodeState.MotionState.self, forKey: .motionState)
        
        self.init(nodeType: nodeType,
                  date: date,
                  degrees: degrees,
                  perihelion: perihelion,
                  ascendingNode: ascendingNode,
                  inclination: inclination,
                  eccentricity: eccentricity,
                  motionState: motionState)
    }
    // StarChart Init
    convenience init?(starChart: StarChart, nodeType: PlanetNodeType, motionState:PlanetNodeState.MotionState? = nil) {
        
        guard let planetNode = starChart.planetNodes[nodeType],
              let planet = planetNode.nodeType.planet(starChart: starChart) else { return nil }
        
        self.init(nodeType: nodeType,
                  date: starChart.date,
                  degrees: planet.equatorialCoordinates.alpha.value,
                  perihelion: planet.longitudeOfPerihelion().value,
                  ascendingNode: planet.longitudeOfAscendingNode().value,
                  inclination: planet.inclination().value,
                  eccentricity: planet.eccentricity(),
                  motionState: motionState)
    }
    
    // MARK: Accessors
    // Hash Number
    public var hash: Int {
        return PlanetNodeStateHash(date: date, nodeType: nodeType)
    }
    // Rise
    public var rise:Double {
        return angleDifference(angle1: degrees, angle2: ascendingNode)/180
    }
    // Fall
    public var fall:Double {
        return angleDifference(angle1: degrees, angle2: ascendingNode+180)/180
    }
    // Exa
    public var exaltation:Double {
        return angleDifference(angle1: degrees, angle2: perihelion)/180
    }
    // Deb
    public var debilitation:Double {
        return angleDifference(angle1: degrees, angle2: perihelion+180)/180
    }
    
    // MARK: Methods
    // Angle Difference
    public func angleDifference(angle1: Double, angle2: Double ) -> Double {
        let diff: Double = ( angle2 - angle1 + 180.0 ).truncatingRemainder(dividingBy: 360.0) - 180.0
        return diff < -180 ? diff + 360 : diff
    }
}

// MARK: Codable
extension PlanetNodeState: Codable {
    // Codable Planet Node State
    public nonisolated func rawData() throws -> Data { return try JSONEncoder().encode(self) }
    public nonisolated static func from(_ rawData: Data) throws -> PlanetNodeState { return try JSONDecoder().decode(PlanetNodeState.self, from: rawData) }
    // Coding Keys
    enum CodingKeys: CodingKey {
        case nodeType
        case date
        case degrees
        case perihelion
        case ascendingNode
        case inclination
        case eccentricity
        case motionState
    }
    // Encode
    nonisolated public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nodeType, forKey: .nodeType)
        try container.encode(date, forKey: .date)
        try container.encode(degrees, forKey: .degrees)
        try container.encode(perihelion, forKey: .perihelion)
        try container.encode(ascendingNode, forKey: .ascendingNode)
        try container.encode(inclination, forKey: .inclination)
        try container.encode(eccentricity, forKey: .eccentricity)
        try container.encode(motionState, forKey: .motionState)
    }
    
}

// MARK: Hashable
// Hashable Planet Node State
extension PlanetNodeState: Hashable {
    // Hash Key
    public nonisolated var hashKey: String { return String(hashValue) }
    // Equatable
    public static func == (lhs: PlanetNodeState, rhs: PlanetNodeState) -> Bool {
        return lhs.date == rhs.date && lhs.nodeType == rhs.nodeType
    }
    // Hash Into
    nonisolated public func hash(into hasher: inout Hasher) {
        hasher.combine(nodeType)
        hasher.combine(date)
    }
}


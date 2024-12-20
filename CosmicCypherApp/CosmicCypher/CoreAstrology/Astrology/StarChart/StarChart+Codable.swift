//
//  StarChart+Codable.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/6/22.
//

import Foundation
import SwiftAA

extension StarChart: Codable {
    
    public func rawData() throws -> Data { return try JSONEncoder().encode(self) }
    public static func from(_ rawData: Data) throws -> StarChart { return try JSONDecoder().decode(StarChart.self, from: rawData) }
    
    enum CodingKeys: CodingKey {
        case celestialOffset
        case alignments
        case aspects
        case date
        case coordinates
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(celestialOffset, forKey: .celestialOffset)
        let nodes:[PlanetNode] = planetNodes.values.map({$0})
        try container.encode(nodes, forKey: .alignments)
        try container.encode(aspects, forKey: .aspects)
        try container.encode(date, forKey: .date)
        try container.encode(coordinates, forKey: .coordinates)
    }
    
    public convenience init(from decoder: Decoder) throws {
        //print("decoding StarChart")
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let celestialOffset:CoreAstrology.Ayanamsa = try container.decode(CoreAstrology.Ayanamsa.self, forKey: .celestialOffset)
        let nodes:[PlanetNode] = try container.decode([PlanetNode].self, forKey: .alignments)
        let aspects:[CoreAstrology.Aspect] = try container.decode([CoreAstrology.Aspect].self, forKey: .aspects)
        let date:Date = try container.decode(Date.self, forKey: .date)
        let coordinates:GeographicCoordinates = try container.decode(GeographicCoordinates.self, forKey: .coordinates)
        
        var storedPlanetNodes = StarChartPlanetNodes()
        for node in nodes {
            storedPlanetNodes[node.nodeType] = node
        }
        
        self.init(date: date,
                  coordinates: coordinates,
                  celestialOffset: celestialOffset,
                  planetNodes: storedPlanetNodes,
                  aspects: aspects)
    }
    
    public convenience init(copy starChart:StarChart) {
        self.init(date: starChart.date,
                  coordinates: starChart.coordinates,
                  celestialOffset: starChart.celestialOffset,
                  planetNodes: starChart.planetNodes,
                  aspects: starChart.aspects)
    }
}

extension CoreAstrology.Aspect: Codable {
    
    enum CodingKeys: CodingKey {
        case primaryBody
        case relation
        case secondaryBody
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(primaryBody, forKey: .primaryBody)
        try container.encode(relation, forKey: .relation)
        try container.encode(secondaryBody, forKey: .secondaryBody)
    }
    
    public convenience init(from decoder: Decoder) throws {
        //print("decoding Aspect")
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let primaryBody:CoreAstrology.AspectBody = try container.decode(CoreAstrology.AspectBody.self, forKey: .primaryBody)
        let relation:CoreAstrology.AspectRelation = try container.decode(CoreAstrology.AspectRelation.self, forKey: .relation)
        let secondaryBody:CoreAstrology.AspectBody = try container.decode(CoreAstrology.AspectBody.self, forKey: .secondaryBody)
        
        self.init(primaryBody: primaryBody,
                  relation: relation,
                  secondaryBody: secondaryBody)
    }
    
}

extension CoreAstrology.AspectRelation: Codable {
    
    enum CodingKeys: CodingKey {
        case nodeDistance
        case type
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nodeDistance, forKey: .nodeDistance)
        try container.encode(type, forKey: .type)
    }
    
    public convenience init(from decoder: Decoder) throws {
        //print("decoding AspectRelation")
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nodeDistance = try container.decode(Degree.self, forKey: .nodeDistance)
        let type = try container.decode(CoreAstrology.AspectRelationType.self, forKey: .type)
        self.init(nodeDistance: nodeDistance, forceWith: type)
    }
}

extension CoreAstrology.AspectBody: Codable {
    
    enum CodingKeys: CodingKey {
        case equatorialCoordinates
        case type
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(equatorialCoordinates, forKey: .equatorialCoordinates)
        try container.encode(type, forKey: .type)
    }
    
    public init(from decoder: Decoder) throws {
        //print("decoding AspectBody")
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let equatorialCoordinates = try container.decode(EquatorialCoordinates.self, forKey: .equatorialCoordinates)
        let type = try container.decode(CoreAstrology.AspectBody.NodeType.self, forKey: .type)
        self.init(equatorialCoordinates: equatorialCoordinates, type: type)
    }
}

extension CoreAstrology.AspectBody.NodeType: Codable {}

extension CoreAstrology.Ayanamsa: Codable {
    
    enum CodingKeys: CodingKey {
        case rawValue
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(rawValue, forKey: .rawValue)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue = try container.decode(Double.self, forKey: .rawValue)
        guard let ayanamsa = CoreAstrology.Ayanamsa(rawValue: rawValue) else {
            throw DecodeError.runtimeError("rawValue out of bounds for enum: \(rawValue)")
        }
        self = ayanamsa
    }
    
    enum DecodeError: Error {
        case runtimeError(String)
    }
}

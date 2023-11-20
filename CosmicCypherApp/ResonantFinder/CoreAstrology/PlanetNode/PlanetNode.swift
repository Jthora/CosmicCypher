//
//  PlanetNode.swift
//  EarthquakeFinderCreateML
//
//  Created by Jordan Trana on 9/24/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import Foundation
import SwiftAA

// MARK: Planet Node
public class PlanetNode: Codable {
    
    // MARK: Properties
    // Node
    public var parent:PlanetNode?
    public lazy var children:[PlanetNode] = []
    public let nodeType:PlanetNodeType
    public let date:Date
    public let rawLongitude:Degree // Tropical Astrology
    public let ayanamsa:CoreAstrology.Ayanamsa
    public let coordinates:EquatorialCoordinates?
    public let distance:AstronomicalUnit?
    public let gravity:Newtons?
    public let mass:Kilogram?
    
    // MARK: Init
    // init
    public init(date: Date,
                ayanamsa: CoreAstrology.Ayanamsa = .galacticCenter,
                nodeType: CoreAstrology.AspectBody.NodeType,
                rawLongitude: Degree,
                coordinates: EquatorialCoordinates?,
                distance: AstronomicalUnit?,
                gravity: Newtons?,
                mass: Kilogram?) {
        self.date = date
        self.ayanamsa = ayanamsa
        self.nodeType = nodeType
        self.rawLongitude = rawLongitude
        self.coordinates = coordinates
        self.distance = distance
        self.gravity = gravity
        self.mass = mass
    }
    
    // Special Init
    public init?(nodeType:CoreAstrology.AspectBody.NodeType, date:Date, coordinates: GeographicCoordinates, ayanamsa:CoreAstrology.Ayanamsa = .galacticCenter) {
        guard let longitude = nodeType.geocentricLongitude(date: date, coords: coordinates) else {
            print("ERROR: aspectBody: \(nodeType) can't calculate geocentricLongitude")
            return nil
        }
        self.nodeType = nodeType
        self.date = date
        self.ayanamsa = ayanamsa
        self.rawLongitude = Degree(longitude.value.rounded(toIncrement: 0.1))
        self.coordinates = nodeType.equatorialCoordinates(date: date)
        self.distance = nodeType.distanceFromEarth(date: date)
        self.gravity = nodeType.gravimetricForceOnEarth(date: date)
        self.mass = nodeType.massOfPlanet()
    }
    
    // Codable Init
    required public convenience init(from decoder: Decoder) throws {
        //print("decoding AstrologicalNode")
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let date:Date = try container.decode(Date.self, forKey: .date)
        let ayanamsa:CoreAstrology.Ayanamsa = try container.decode(CoreAstrology.Ayanamsa.self, forKey: .ayanamsa)
        let nodeType:CoreAstrology.AspectBody.NodeType = try container.decode(CoreAstrology.AspectBody.NodeType.self, forKey: .nodeType)
        let rawLongitude:Degree = try container.decode(Degree.self, forKey: .rawLongitude)
        let coordinates:EquatorialCoordinates? = try container.decode(EquatorialCoordinates?.self, forKey: .coordinates)
        let distance:AstronomicalUnit? = try container.decode(AstronomicalUnit?.self, forKey: .distance)
        let gravity:Newtons? = try Newtons(container.decode(Double?.self, forKey: .gravity) ?? 0)
        let mass:Kilogram? = try container.decode(Kilogram?.self, forKey: .mass)
        
        self.init(date: date,
                  ayanamsa: ayanamsa,
                  nodeType: nodeType,
                  rawLongitude: rawLongitude,
                  coordinates: coordinates,
                  distance: distance,
                  gravity: gravity,
                  mass: mass)
    }
    
    // MARK: Accessors
    // Correct Longitude
    public var longitude:Degree {
        return rawLongitude - ayanamsa.degrees(for: date) // Apply Celestial Offset
    }
    
    // Sub Type
    public var subType:PlanetNodeSubType {
        switch nodeType {
        case .sun, .moon, .mercury, .venus, .mars, .jupiter, .saturn, .uranus, .neptune, .pluto: return .body
        case .lunarAscendingNode, .ascendant: return .ascending
        case .lunarDecendingNode, .decendant: return .decending
        case .lunarApogee: return .apogee
        case .lunarPerigee: return .perigee
        case .midheaven, .imumCoeli, .partOfFortune, .partOfSpirit, .partOfEros: return .point
        }
    }
    
    
    // MARK: Methods
    // Chevron
    public func createChevron() -> Chevron {
        return Chevron(node: self)
    }
    // Arcana
    public func createArcana() -> Arcana {
        return Arcana(degree: self.longitude)
    }
    
    // MARK: Codable
    // Coding Keys
    enum CodingKeys: CodingKey {
        case date
        case ayanamsa
        case nodeType
        case rawLongitude
        case coordinates
        case distance
        case gravity
        case mass
    }
    // Encode
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(ayanamsa, forKey: .ayanamsa)
        try container.encode(nodeType, forKey: .nodeType)
        try container.encode(rawLongitude, forKey: .rawLongitude)
        try container.encode(coordinates, forKey: .coordinates)
        try container.encode(distance, forKey: .distance)
        try container.encode(gravity?.value, forKey: .gravity)
        try container.encode(mass, forKey: .mass)
    }
    
}

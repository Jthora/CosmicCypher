//
//  AstrologicalNode.swift
//  EarthquakeFinderCreateML
//
//  Created by Jordan Trana on 9/24/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import Foundation
import SwiftAA

public final class AstrologicalNode: Codable {
    
    public var parent:AstrologicalNode?
    public lazy var children:[AstrologicalNode] = []
    
    public let nodeType:AstrologicalNodeType
    public let date:Date
    public let rawLongitude:Degree // Only use for Tropical Astrology
    
    public let ayanamsa:CoreAstrology.Ayanamsa
    public let coordinates:EquatorialCoordinates?
    public let distance:AstronomicalUnit?
    public let gravity:Double?
    public let mass:Kilogram?
    
    // Ayanamsa is the Celestial Offset according to the Precession of the Equanox
    /// Only use "realLongitude"... rawLongitude is "Tropical" and not "Sidereal" == Tropical means the longitude does not attribute for celestial offset and you will be stuck using an Occult Corrupted version of CoreAstrology.
    /// History: Tropical Astrology was created by Western Occultist Luciferians to trick people into calculating their astrology incorrectly.
    /// However: Vedic Astrology, for example, uses the Sidereal Astrology which can be used to account for the celestial offset by referencing a star closest to the center of the galaxy in the sky!
    /// Galactic Centered Sidereal Astrology: takes into account the location of the Galactic Central Core to accurately offset the Longitude relative to the Precession of the Equinox!
    /// Ayanamsa: is the Sidereal Offset for Longitude
    /// ⚠️ USE SIDEREAL ASTROLOGY -> Only use Galactic Centered Sidereal Astrology for accurate calculations
    public var longitude:Degree {
        return rawLongitude - ayanamsa.degrees(for: date) // Apply Celestial Offset
    }
    
//    
//    var name:String {
//        return aspectBody.rawValue
//    }
    
    public var subType:AstrologicalNodeSubType {
        switch nodeType {
        case .sun, .moon, .mercury, .venus, .mars, .jupiter, .saturn, .uranus, .neptune, .pluto: return .body
        case .lunarAscendingNode, .ascendant: return .ascending
        case .lunarDecendingNode, .decendant: return .decending
        case .lunarApogee: return .apogee
        case .lunarPerigee: return .perigee
        case .midheaven, .imumCoeli, .partOfFortune, .partOfSpirit, .partOfEros: return .point
        }
    }
    
    public init(date: Date,
                ayanamsa: CoreAstrology.Ayanamsa = .galacticCenter,
                nodeType: CoreAstrology.AspectBody.NodeType,
                rawLongitude: Degree,
                coordinates: EquatorialCoordinates?,
                distance: AstronomicalUnit?,
                gravity: Double?,
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
    
    public func createChevron() -> Chevron {
        return Chevron(node: self)
    }
    
    public func createArcana() -> Arcana {
        return Arcana(degree: self.longitude)
    }
    
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
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(ayanamsa, forKey: .ayanamsa)
        try container.encode(nodeType, forKey: .nodeType)
        try container.encode(rawLongitude, forKey: .rawLongitude)
        try container.encode(coordinates, forKey: .coordinates)
        try container.encode(distance, forKey: .distance)
        try container.encode(gravity, forKey: .gravity)
        try container.encode(mass, forKey: .mass)
    }
    
    public convenience init(from decoder: Decoder) throws {
        //print("decoding AstrologicalNode")
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let date:Date = try container.decode(Date.self, forKey: .date)
        let ayanamsa:CoreAstrology.Ayanamsa = try container.decode(CoreAstrology.Ayanamsa.self, forKey: .ayanamsa)
        let nodeType:CoreAstrology.AspectBody.NodeType = try container.decode(CoreAstrology.AspectBody.NodeType.self, forKey: .nodeType)
        let rawLongitude:Degree = try container.decode(Degree.self, forKey: .rawLongitude)
        let coordinates:EquatorialCoordinates? = try container.decode(EquatorialCoordinates?.self, forKey: .coordinates)
        let distance:AstronomicalUnit? = try container.decode(AstronomicalUnit?.self, forKey: .distance)
        let gravity:Double? = try container.decode(Double?.self, forKey: .gravity)
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
}

//
//  AstrologicalNode.swift
//  EarthquakeFinderCreateML
//
//  Created by Jordan Trana on 9/24/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import Foundation
import SwiftAA

enum AstrologicalNodeType {
    case body
    case apogee // .
    case perigee // o
    case ascending
    case decending
    case point
}

class AstrologicalNode {
    
    var parent:AstrologicalNode?
    lazy var children:[AstrologicalNode] = []
    
    let date:Date
    let ayanamsa:Astrology.Ayanamsa
    let aspectBody:Astrology.AspectBody
    let longitude:Degree
    let coordinates:EquatorialCoordinates?
    let distance:AstronomicalUnit?
    let gravity:Double?
    let mass:Kilogram?
    
    var realLongitude:Degree {
        longitude - ayanamsa.degrees(for: date)
    }
    
    var exaltation:Degree? {
        return aspectBody.exaltation
    }
//    
//    var name:String {
//        return aspectBody.rawValue
//    }
    
    var type:AstrologicalNodeType {
        switch aspectBody {
        case .sun, .moon, .mercury, .venus, .mars, .jupiter, .saturn, .uranus, .neptune, .pluto: return .body
        case .lunarAscendingNode, .ascendant: return .ascending
        case .lunarDecendingNode, .decendant: return .decending
        case .lunarApogee: return .apogee
        case .lunarPerigee: return .perigee
        case .midheaven, .imumCoeli, .partOfFortune, .partOfSpirit, .partOfEros: return .point
        }
    }
    
    init?(aspectBody:Astrology.AspectBody, date:Date, coords: GeographicCoordinates, ayanamsa:Astrology.Ayanamsa = .galacticCenter) {
        guard let longitude = aspectBody.geocentricLongitude(date: date, coords: coords) else {
            print("ERROR: aspectBody: \(aspectBody) can't calculate geocentricLongitude")
            return nil
        }
        self.aspectBody = aspectBody
        self.date = date
        self.ayanamsa = ayanamsa
        self.longitude = Degree(longitude.value.rounded(toIncrement: 0.1))
        self.coordinates = aspectBody.equatorialCoordinates(date: date)
        self.distance = aspectBody.distanceFromEarth(date: date)
        self.gravity = aspectBody.gravimetricForceOnEarth(date: date)
        self.mass = aspectBody.massOfPlanet()
    }
    
    func createChevron() -> Chevron {
        return Chevron(node: self)
    }
    
    func createArcana() -> Arcana {
        return Arcana(degree: self.longitude)
    }
    
}

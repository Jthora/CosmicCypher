//
//  Astrology.swift
//  HelmKit
//
//  Created by Jordan Trana on 7/24/18.
//  Copyright © 2018 Jordan Trana. All rights reserved.
//

import UIKit
import SwiftAA

class Astrology {
    
    
    
    class AspectRelation {
        
        var type:AspectRelationType
        var degrees:Degree
        
        enum AspectRelationCategory {
            case ease
            case difficulty
            case creativity
            case improbability
            case transcendance
            case divinity
            case unknown
        }
        
        var category:AspectRelationCategory {
            switch type {
            case .conjunction, .sextile, .trine, .oneTwelfth: return .ease
            case .opposition, .square, .semisquare, .bisemisquare, .fiveTwelfth: return .difficulty
            case .quintile, .biquintile: return .creativity
            case .septile, .biseptile, .triseptile: return .improbability
            case .novile, .binovile, .quadranovile: return .transcendance
            case .oneEleventh, .twoEleventh, .threeEleventh, .fourEleventh, .fiveEleventh: return .divinity
            default: return .unknown
            }
        }
        
        var isEase:Bool {
            switch type {
            case .conjunction, .sextile, .trine: return true
            default: return false
            }
        }
        var isDifficult:Bool {
            switch type {
            case .opposition, .square, .semisquare, .bisemisquare: return true
            default: return false
            }
        }
        var isMagic:Bool {
            switch type {
            case .conjunction, .sextile, .trine: return true
            default: return false
            }
        }
        
        var orbDistance:Degree {
            return type.degree - abs(degrees)
        }
        
        var concentration:Double {
            let ratio = 1-(abs(self.orbDistance.value)/self.type.orb.value)
            return Double(ratio)
        }
        
        init(degrees:Degree, forceWith t: AspectRelationType) {
            self.degrees = degrees
            self.type = t
        }
        
        init?(degrees:Degree) {
            self.degrees = degrees
            guard let t = AspectRelationType(degreeOffset: degrees) else {return nil}
            self.type = t
        }
        
        var defaultDescription:String {
            return type.defaultDescription
        }
        
    }
    
    enum AspectRelationType:Double, CaseIterable {
        
        init?(degreeOffset:Degree) {
            var relationType:AspectRelationType? = nil
            var lastDistance:Degree = 360
            for thisRelation in AspectRelationType.allCases {
                if thisRelation.withinOrb(orbitDegreeOffset: degreeOffset) {
                    if relationType == nil {
                        relationType = thisRelation
                        lastDistance = thisRelation.distance(orbitDegreeOffset: degreeOffset)
                    } else if lastDistance > thisRelation.distance(orbitDegreeOffset: degreeOffset) {
                        relationType = thisRelation
                        lastDistance = thisRelation.distance(orbitDegreeOffset: degreeOffset)
                    }
                }
            }
            guard let type = relationType else {
                //print("WARNING: AspectRelationType is nil for degreeOffset \(degreeOffset)")
                return nil
            }
            self = type
        }
        
        case conjunction = 0
        case opposition = 180
        
        case sextile = 60
        case trine = 120
        
        case semisquare = 45
        case square = 90
        case bisemisquare = 135
        
        case quintile = 72
        case biquintile = 144
        
        case septile = 51.4285714286
        case biseptile = 102.857142857
        case triseptile = 154.285714286
        
        case novile = 40
        case binovile = 80
        case quadranovile = 160
        
        case oneTenth = 36
        case threeTenth = 108
        
        case oneEleventh = 32.72727272727
        case twoEleventh = 65.45454545455
        case threeEleventh = 98.18181818182
        case fourEleventh = 130.90909090909
        case fiveEleventh = 163.63636363636
        
        case oneTwelfth = 30 // semisextile
        case fiveTwelfth = 150 // fiveTwelfth
        
        var degree:Degree {
            return Degree(self.rawValue)
        }
        
        func distance(orbitDegreeOffset:Degree) -> Degree {
            return abs(orbitDegreeOffset - self.degree)
        }
        
        func withinOrb(orbitDegreeOffset:Degree) -> Bool {
            return orbitDegreeOffset > self.degree - self.orb && orbitDegreeOffset < self.degree + self.orb
        }
        
        var isEasyAspect:Bool {
            switch self {
            case .novile, .binovile, .quadranovile, .oneTwelfth, .sextile, .trine:
                return true
            default:
                return false
            }
        }
        
        var priority:Double {
            switch self {
            case .conjunction: return 30 // (360*( 1/1 ))/12
            case .opposition: return 15 // (360*( 1/2 ))/12
            case .trine: return 10 // (360*( 1/3 ))/12
            case .square: return 7.5 // (360*( 1/4 ))/12
            case .quintile: return 6 // (360*( 1/5 ))/12
            case .biquintile: return 6 // (360*( 1/5 ))/12
            case .sextile: return 5 // (360*( 1/6 ))/12
            case .septile: return 4.3 // (360*( 1/7 ))/12
            case .biseptile: return 4.2 // (360*( 1/7 ))/12
            case .triseptile: return 4.1 // (360*( 1/7 ))/12
            case .semisquare: return 3.6 // (360*( 1/8 ))/12
            case .bisemisquare: return 3.5 // (360*( 1/8 ))/12
            case .novile: return 3.4 // (360*( 1/9 ))/12
            case .binovile: return 3.3 // (360*( 1/9 ))/12
            case .quadranovile: return 3.2 // (360*( 1/9 ))/12
            case .oneTenth: return 3.1 // (360*( 1/10 ))/12
            case .threeTenth: return 3 // (360*( 1/10 ))/12
            case .oneEleventh: return 2.7  // (360*( 1/11 ))/12
            case .twoEleventh: return 2.6  // (360*( 1/11 ))/12
            case .threeEleventh: return 2.5  // (360*( 1/11 ))/12
            case .fourEleventh: return 2.4  // (360*( 1/11 ))/12
            case .fiveEleventh: return 2.3  // (360*( 1/11 ))/12
            case .oneTwelfth: return 2.2 // (360*( 1/12 ))/12
            case .fiveTwelfth: return 2.1 // (360*( 1/12 ))/12
            }
        }
        
        var orb:Degree {
            switch self {
            case .conjunction: return 30 // (360*( 1/1 ))/12
            case .opposition: return 15 // (360*( 1/2 ))/12
            case .trine: return 10 // (360*( 1/3 ))/12
            case .square: return 7.5 // (360*( 1/4 ))/12
            case .quintile: return 6 // (360*( 1/5 ))/12
            case .biquintile: return 6 // (360*( 1/5 ))/12
            case .sextile: return 5 // (360*( 1/6 ))/12
            case .septile: return 4.28571428571 // (360*( 1/7 ))/12
            case .biseptile: return 4.28571428571 // (360*( 1/7 ))/12
            case .triseptile: return 4.28571428571 // (360*( 1/7 ))/12
            case .semisquare: return 3.75 // (360*( 1/8 ))/12
            case .bisemisquare: return 3.75 // (360*( 1/8 ))/12
            case .novile: return 3.33333333333 // (360*( 1/9 ))/12
            case .binovile: return 3.33333333333 // (360*( 1/9 ))/12
            case .quadranovile: return 3.33333333333 // (360*( 1/9 ))/12
            case .oneTenth: return 3 // (360*( 1/10 ))/12
            case .threeTenth: return 3 // (360*( 1/10 ))/12
            case .oneEleventh: return 2.72727272727  // (360*( 1/11 ))/12
            case .twoEleventh: return 2.72727272727  // (360*( 1/11 ))/12
            case .threeEleventh: return 2.72727272727  // (360*( 1/11 ))/12
            case .fourEleventh: return 2.72727272727  // (360*( 1/11 ))/12
            case .fiveEleventh: return 2.72727272727  // (360*( 1/11 ))/12
            case .oneTwelfth: return 2.5 // (360*( 1/12 ))/12
            case .fiveTwelfth: return 2.5 // (360*( 1/12 ))/12
            }
        }
        
        var fraction:String {
            switch self {
            case .conjunction: return "1/1"
            case .opposition: return "1/2"
            case .trine: return "1/3"
            case .square: return "1/4"
            case .quintile: return "1/5"
            case .biquintile: return "2/5"
            case .sextile: return "1/6"
            case .septile: return "1/7"
            case .biseptile: return "2/7"
            case .triseptile: return "3/7"
            case .semisquare: return "1/8"
            case .bisemisquare: return "3/8"
            case .novile: return "1/9"
            case .binovile: return "2/9"
            case .quadranovile: return "4/9"
            case .oneTenth: return "1/10"
            case .threeTenth: return "3/10"
            case .oneEleventh: return "1/11"
            case .twoEleventh: return "2/11"
            case .threeEleventh: return "3/11"
            case .fourEleventh: return "4/11"
            case .fiveEleventh: return "5/11"
            case .oneTwelfth: return "1/12"
            case .fiveTwelfth: return "5/12"
            }
        }
        
        var imageName:String {
            switch self {
            case .conjunction: return "AstrologyIcon_Aspect_Conjunct"
            case .opposition: return "AstrologyIcon_Aspect_Opposition"
            case .trine: return "AstrologyIcon_Aspect_Trine"
            case .square: return "AstrologyIcon_Aspect_Square"
            case .quintile, .biquintile: return "AstrologyIcon_Aspect_Fifth"
            case .sextile: return "AstrologyIcon_Aspect_Sextile"
            case .septile, .biseptile, .triseptile: return "AstrologyIcon_Aspect_Seventh"
            case .semisquare, .bisemisquare: return "AstrologyIcon_Aspect_Eighth"
            case .novile, .binovile, .quadranovile: return "AstrologyIcon_Aspect_Ninth"
            case .oneTenth, .threeTenth: return "AstrologyIcon_Aspect_Tenth"
            case .oneEleventh, .twoEleventh, .threeEleventh, .fourEleventh, .fiveEleventh: return "AstrologyIcon_Aspect_Eleventh"
            case .oneTwelfth, .fiveTwelfth: return "AstrologyIcon_Aspect_Twelfth"
            }
        }
        
        var image:UIImage {
            switch self {
            case .conjunction: return Assets.Images.AspectSymbols.conjunct
            case .opposition: return Assets.Images.AspectSymbols.opposition
            case .trine: return Assets.Images.AspectSymbols.trine
            case .square: return Assets.Images.AspectSymbols.square
            case .quintile, .biquintile: return Assets.Images.AspectSymbols.fifth
            case .sextile: return Assets.Images.AspectSymbols.sextile
            case .septile, .biseptile, .triseptile: return Assets.Images.AspectSymbols.seventh
            case .semisquare, .bisemisquare: return Assets.Images.AspectSymbols.eighth
            case .novile, .binovile, .quadranovile: return Assets.Images.AspectSymbols.ninth
            case .oneTenth, .threeTenth: return Assets.Images.AspectSymbols.tenth
            case .oneEleventh, .twoEleventh, .threeEleventh, .fourEleventh, .fiveEleventh: return Assets.Images.AspectSymbols.eleventh
            case .oneTwelfth, .fiveTwelfth: return Assets.Images.AspectSymbols.twelfth
            }
        }
        
        var defaultDescription:String {
            switch self {
            case .conjunction: return "Relationships, the blurring of differences"
            case .opposition: return "Relationships, divided loyalties"
                
            case .sextile: return "Friendly, with some talent, ease, and oomph"
            case .trine: return "Support, pleasure"
                
            case .semisquare: return "Friction, prompt action to reduce friction"
            case .square: return "Tension, expect difficulty and growth"
            case .bisemisquare: return ""

            case .oneTwelfth: return "Dissociation, helping another"
            case .fiveTwelfth: return "Challenging, misunderstanding and difference"
                
            case .quintile: return "Unleashed talent, use of creative energy"
            case .biquintile: return "Unleashed talent, use of creative energy"
                
            case .septile: return ""
            case .biseptile: return ""
            case .triseptile: return ""
                
            case .novile: return "Initiation, successful"
            case .binovile: return "Initiation, successful"
            case .quadranovile: return "Initiation, successful"
                
            default: return ""
            }
        }
    }
    
    enum AspectBody: Int, CaseIterable {
        case sun
        case moon
        case mercury
        case venus
        case mars
        case jupiter
        case saturn
        case uranus
        case neptune
        case pluto
        case ascendant
        case decendant
        case midheaven
        case imumCoeli
        case lunarAscendingNode
        case lunarDecendingNode
        case lunarApogee
        case lunarPerigee
        case partOfFortune
        case partOfSpirit
        case partOfEros
        
        init?(with planet:PlanetaryBase) {
            switch planet.planetaryObject {
            case .MERCURY: self = .mercury
            case .VENUS: self = .venus
            case .MARS: self = .mars
            case .JUPITER: self = .jupiter
            case .SATURN: self = .saturn
            case .URANUS: self = .uranus
            case .NEPTUNE: self = .neptune
            default: return nil
            }
        }
        
        var imageName:String? {
            switch self {
            case .moon: return "AstrologyIcon_Node_Moon"
            case .sun: return "AstrologyIcon_Node_Sun"
            case .mercury: return "AstrologyIcon_Planet_Mercury"
            case .venus: return "AstrologyIcon_Planet_Venus"
            case .mars: return "AstrologyIcon_Planet_Mars"
            case .jupiter: return "AstrologyIcon_Planet_Jupiter"
            case .saturn: return "AstrologyIcon_Planet_Saturn"
            case .uranus: return "AstrologyIcon_Planet_Uranus"
            case .neptune: return "AstrologyIcon_Planet_Neptune"
            case .pluto: return "AstrologyIcon_Planet_Pluto"
            case .ascendant: return "AstrologyIcon_Node_ASC"
            case .decendant: return "AstrologyIcon_Node_DSC"
            case .midheaven: return "AstrologyIcon_Node_MC"
            case .imumCoeli: return "AstrologyIcon_Node_IC"
            case .lunarAscendingNode: return "AstrologyIcon_Node_NorthNode"
            case .lunarDecendingNode: return "AstrologyIcon_Node_SouthNode"
            case .lunarApogee: return "AstrologyIcon_Node_AntiLilith"
            case .lunarPerigee: return "AstrologyIcon_Node_Lilith"
            case .partOfFortune: return "AstrologyIcon_Part_Fortune"
            case .partOfSpirit: return "AstrologyIcon_Part_Spirit"
            case .partOfEros: return "AstrologyIcon_Part_Eros"
            }
        }
        
        var image:UIImage? {
            guard let name = imageName else {return nil}
            return UIImage(named: name)
        }
        
        
        var exaltation:Degree? {
            switch self {
            case .sun: return 19
            case .moon: return 33
            case .mercury: return 165
            case .venus: return 357
            case .mars: return 298
            case .jupiter: return 105
            case .saturn: return 201
            case .lunarAscendingNode: return 50
            default: return nil
            }
        }
        
        var symbol:String {
            switch self {
            case .moon: return "☽"
            case .sun: return "☉"
            case .mercury: return "☿"
            case .venus: return "♀"
            case .mars: return "♂︎"
            case .jupiter: return "♃"
            case .saturn: return "♄"
            case .uranus: return "♅"
            case .neptune: return "♆"
            case .pluto: return "♇"
            default: return ""
            }
        }
        
        var defaultDescription:String {
            switch self {
            case .moon: return "Feelings, moods and senses"
            case .sun: return "Core, self and identity"
            case .mercury: return "Communication, thinking and reason"
            case .venus: return "Favorite, attraction, pleasure"
            case .mars: return "Action, bravery and agression"
            case .jupiter: return "Motivation, abundance and growth"
            case .saturn: return "Authority, boundaries and rules"
            case .uranus: return "Surpise, reversals and breakthroughs"
            case .neptune: return "Romance, avoidance and fantasy"
            case .pluto: return "Destruction, reincarnation and regeneration"
            default: return ""
            }
        }
        
        static var bodiesWithGravity:[AspectBody] = [.moon,
                                                     .sun,
                                                     .mercury,
                                                     .venus,
                                                     .mars,
                                                     .jupiter,
                                                     .saturn,
                                                     .uranus,
                                                     .neptune,
                                                     .pluto]
        

        func equatorialCoordinates(date:Date, highPrecision:Bool = true) -> EquatorialCoordinates? {
            let julianDay = JulianDay(date)
            switch self {
            case .sun: return Sun(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates
            case .moon: return Moon(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates
            case .mercury: return Mercury(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates
            case .venus: return Venus(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates
            case .mars: return Mars(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates
            case .jupiter: return Jupiter(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates
            case .saturn: return Saturn(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates
            case .uranus: return Uranus(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates
            case .neptune: return Neptune(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates
            case .pluto: return Pluto(julianDay: julianDay, highPrecision: highPrecision).apparentGeocentricEquatorialCoordinates
            default: return nil
            }
        }

        func geocentricLongitude(date:Date, coords:GeographicCoordinates = GeographicCoordinates(positivelyWestwardLongitude: 0, latitude: 0), highPrecision:Bool = true) -> Degree? {
            let julianDay = JulianDay(date)
            switch self {
            case .sun: return Sun(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
            case .moon: return Moon(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
            case .mercury: return Mercury(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
            case .venus: return Venus(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
            case .mars: return Mars(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
            case .jupiter: return Jupiter(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
            case .saturn: return Saturn(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
            case .uranus: return Uranus(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
            case .neptune: return Neptune(julianDay: julianDay, highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
            case .pluto: return Pluto(julianDay: julianDay, highPrecision: highPrecision).apparentGeocentricEquatorialCoordinates.alpha.inDegrees
            case .lunarApogee: return Moon(julianDay:Moon(julianDay:julianDay, highPrecision: highPrecision).apogee(), highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
            case .lunarPerigee: return Moon(julianDay:Moon(julianDay:julianDay, highPrecision: highPrecision).perigee(), highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
            case .lunarAscendingNode: return Moon(julianDay:Moon(julianDay:julianDay, highPrecision: highPrecision).passageThroughAscendingNode(), highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
            case .lunarDecendingNode: return Moon(julianDay:Moon(julianDay:julianDay, highPrecision: highPrecision).passageThroughDescendingNode(), highPrecision: highPrecision).equatorialCoordinates.alpha.inDegrees
            case .ascendant: return Earth(julianDay: julianDay, highPrecision: highPrecision).getASC(coords: coords)
            case .decendant: return Earth(julianDay: julianDay, highPrecision: highPrecision).getCelestialLongitudeOfHouseCusp(house: .seventh, coords: coords)
            case .midheaven: return Earth(julianDay: julianDay, highPrecision: highPrecision).getMidHeaven(coords: coords)
            case .imumCoeli: return Earth(julianDay: julianDay, highPrecision: highPrecision).getCelestialLongitudeOfHouseCusp(house: .forth, coords: coords)
            case .partOfFortune: return Earth(julianDay: julianDay, highPrecision: highPrecision).getPartOfFortune(coords: coords)
            case .partOfSpirit: return Earth(julianDay: julianDay, highPrecision: highPrecision).getPartOfSpirit(coords: coords)
            case .partOfEros: return Earth(julianDay: julianDay, highPrecision: highPrecision).getPartOfEros(coords: coords)
            }
        }
        
        func distanceFromEarth(date:Date, highPrecision:Bool = true) -> AstronomicalUnit? {
            let julianDay = JulianDay(date)
            switch self {
            case .sun: return Sun(julianDay: julianDay, highPrecision: highPrecision).radiusVector
            case .moon: return Moon(julianDay: julianDay, highPrecision: highPrecision).radiusVector
            case .mercury: return Mercury(julianDay: julianDay, highPrecision: highPrecision).trueGeocentricDistance
            case .venus: return Venus(julianDay: julianDay, highPrecision: highPrecision).trueGeocentricDistance
            case .mars: return Mars(julianDay: julianDay, highPrecision: highPrecision).trueGeocentricDistance
            case .jupiter: return Jupiter(julianDay: julianDay, highPrecision: highPrecision).trueGeocentricDistance
            case .saturn: return Saturn(julianDay: julianDay, highPrecision: highPrecision).trueGeocentricDistance
            case .uranus: return Uranus(julianDay: julianDay, highPrecision: highPrecision).trueGeocentricDistance
            case .neptune: return Neptune(julianDay: julianDay, highPrecision: highPrecision).trueGeocentricDistance
            case .pluto: return Pluto(julianDay: julianDay, highPrecision: highPrecision).trueGeocentricDistance
            default: return nil
            }
        }
        
        func massOfPlanet() -> Kilogram? {
            switch self {
            case .sun: return 1.9885e30
            case .moon: return 7.342e22
            case .mercury: return 3.3011e23
            case .venus: return 4.8675e24
            case .mars: return 6.4171e23
            case .jupiter: return 1.8982e27
            case .saturn: return 5.6834e26
            case .uranus: return 8.6810e25
            case .neptune: return 1.02413e26
            case .pluto: return 1.303e22
            default: return nil
            }
        }
        
        func gravimetricForceOnEarth(date:Date) -> Double? {
            guard let mass = massOfPlanet(),
                let distanceInMeters = distanceFromEarth(date: date)?.inMeters.value else {
                    return nil
            }
            let earthMass:Kilogram = 5.97237e24
            let universalGravityConstant:Double = 6.673e-11
            return (universalGravityConstant*earthMass*mass)/(distanceInMeters*distanceInMeters)
        }
    }
    
    class Aspect {
        var primaryBody:AspectBody
        var relation:AspectRelation
        var secondaryBody:AspectBody
        
        init(primarybody:AspectBody, relation:AspectRelation, secondaryBody:AspectBody) {
            self.primaryBody = primarybody
            self.relation = relation
            self.secondaryBody = secondaryBody
        }
        
        var concentration:Double? {
            return self.relation.concentration
        }
        
        var combinedDescription:String {
            let description = self.description
            let planetaryEffectDescription = self.planetaryEffectDescription()
            if description.count == planetaryEffectDescription.count {
                return self.planetaryEffectDescription(flipPlanets: true)
            }
            return planetaryEffectDescription
        }
        
        func shouldRemove(comparedTo other:Astrology.Aspect) -> Bool {
            if relation.type == other.relation.type && primaryBody == other.secondaryBody && secondaryBody == other.primaryBody {
                return primaryBody.rawValue > other.primaryBody.rawValue
            }
            return false
        }
        
        func angleDiff(for date:Date, coords:GeographicCoordinates, magnitude:Bool = true) -> Degree? {
            
            guard let p1 = self.primaryBody.geocentricLongitude(date: date, coords: coords),
            let p2 = self.secondaryBody.geocentricLongitude(date: date, coords: coords) else {
                return nil
            }
            
            let d = p1 - p2
            
            return magnitude ? abs(d) : d
        }
        
        var description:String {
            return primaryBody.defaultDescription + relation.defaultDescription + secondaryBody.defaultDescription
        }
        
        func planetaryEffectDescription(flipPlanets:Bool = false) -> String {
            
            let relation = self.relation.type
            let primarybody = flipPlanets ? self.secondaryBody : self.primaryBody
            let secondaryBody = flipPlanets ? self.primaryBody : self.secondaryBody
            
            switch primarybody {
            case .sun:
                switch secondaryBody {
                case .moon:
                    switch relation {
                    case .conjunction: return self.description + "Revitalizing, new beginnings"
                    case .sextile: return self.description + "Gain through more work"
                    case .square: return self.description + "Don't force matter; patience needed"
                    case .trine: return self.description + "Ease with the opposite sex"
                    case .fiveTwelfth: return self.description + "Period of self-examination and transformation"
                    case .opposition: return self.description + "Hard work for little gain"
                    default: return self.description
                    }
                case .mercury:
                    switch relation {
                    case .conjunction: return self.description + "Short trip; pay attention to details"
                    default: return self.description
                    }
                case .venus:
                    switch relation {
                    case .conjunction: return self.description + "Personal charm energized"
                    default: return self.description
                    }
                case .mars:
                    switch relation {
                    case .conjunction: return self.description + "Job accented; high energy, quarrels"
                    case .sextile: return self.description + "Nervous energy; need self-control"
                    case .square: return self.description + "Use restraint; quick acting"
                    case .trine: return self.description + "Finish projects, meet people"
                    case .fiveTwelfth: return self.description + "Fitful bursts of dynamic action"
                    case .opposition: return self.description + "Quarrels, energy needs direction"
                    default: return self.description
                    }
                case .jupiter:
                    switch relation {
                    case .conjunction: return self.description + "Get out of a rut; philosophical"
                    case .sextile: return self.description + "Optimistic; big promises and dreams"
                    case .square: return self.description + "Personal problems; be philosophical"
                    case .trine: return self.description + "Financial opportunities, self-assurance"
                    case .fiveTwelfth: return self.description + "Exaggerated self-image can cause disagreements"
                    case .opposition: return self.description + "Extravagance, exaggeration, wasted time"
                    default: return self.description
                    }
                case .saturn:
                    switch relation {
                    case .conjunction: return self.description + "Think seriously about life direction"
                    case .sextile: return self.description + "Success; patient, steady efforts"
                    case .square: return self.description + "Losses from gambling; low energy"
                    case .trine: return self.description + "Good for dealing with authority"
                    case .fiveTwelfth: return self.description + "Minor obsticles presented by authority figures"
                    case .opposition: return self.description + "Hard work; responsibilites pile up"
                    default: return self.description
                    }
                case .uranus:
                    switch relation {
                    case .conjunction: return self.description + "Keep mind on job, magnetism"
                    case .sextile: return self.description + "Original, put creative ideas into action"
                    case .square: return self.description + "Make mistakes, keep action steady"
                    case .trine: return self.description + "Excitement and fun, life of the party"
                    case .fiveTwelfth: return self.description + "Rebellion against selfish interest"
                    case .opposition: return self.description + "Resentment, dicord; be tactful"
                    default: return self.description
                    }
                case .neptune:
                    switch relation {
                    case .conjunction: return self.description + "Active imagination, inspiration"
                    case .sextile: return self.description + "Meditation, inner understanding"
                    case .square: return self.description + "Judgement poor; postpone decisions"
                    case .trine: return self.description + "Idealism, friendship, romance"
                    case .fiveTwelfth: return self.description + "Opportunity to glimpse own spiritual nature"
                    case .opposition: return self.description + "Impractical, idealistic"
                    default: return self.description
                    }
                case .pluto:
                    switch relation {
                    case .conjunction: return self.description + "Increased aggressiveness, independence"
                    case .sextile: return self.description + "Community groups, creative changes"
                    case .square: return self.description + "Others' plans conflict with yours"
                    case .trine: return self.description + "Make progressive changes"
                    case .fiveTwelfth: return self.description + "Struggle between ego and spiritual will"
                    case .opposition: return self.description + "More agressive; possible unwise action"
                    default: return self.description
                    }
                default: return self.description
                }
            case .moon:
                switch secondaryBody {
                case .mercury:
                    switch relation {
                    case .conjunction: return self.description + "Temperamental actions and words"
                    case .sextile: return self.description + "Quick thinking, many ideas"
                    case .square: return self.description + "Restlessness, indecision, worry"
                    case .trine: return self.description + "Reach decisions, persuade others"
                    case .fiveTwelfth: return self.description + "Need for balancing thinking and emotions"
                    case .opposition: return self.description + "Handle routine work and details"
                    default: return self.description
                    }
                case .venus:
                    switch relation {
                    case .conjunction: return self.description + "Ideas of beauty and decoration"
                    case .sextile: return self.description + "Harmony; affectionate, cheerful"
                    case .square: return self.description + "Relax with friends, extravagance"
                    case .trine: return self.description + "Beautiful purchases, redecoration"
                    case .fiveTwelfth: return self.description + "Discrimination required in romantic situations"
                    case .opposition: return self.description + "Excess in emotions, extravagance"
                    default: return self.description
                    }
                case .mars:
                    switch relation {
                    case .conjunction: return self.description + "Keep active, finish tasks"
                    case .sextile: return self.description + "Nervousness and excitement"
                    case .square: return self.description + "Impulsive, emotional thinking"
                    case .trine: return self.description + "Harmony; cheerful and exciting"
                    case .fiveTwelfth: return self.description + "Direct, impulsive emotions"
                    case .opposition: return self.description + "High energy, but not cooperation"
                    default: return self.description
                    }
                case .jupiter:
                    switch relation {
                    case .conjunction: return self.description + "Contentment, optimism; idealistic"
                    case .sextile: return self.description + "Cheerful; cooperation"
                    case .square: return self.description + "Excess, broken promises; impractical"
                    case .trine: return self.description + "Overly optimistic progress with ideas"
                    case .fiveTwelfth: return self.description + "Questions concerning philosophical outlook"
                    case .opposition: return self.description + "Extravagance, should seek enjoyment"
                    default: return self.description
                    }
                case .saturn:
                    switch relation {
                    case .conjunction: return self.description + "Dependability, responsibility"
                    case .sextile: return self.description + "Easy to help those in need; good advice"
                    case .square: return self.description + "Disciplined work, serious thinking"
                    case .trine: return self.description + "Accomplishment through patience"
                    case .fiveTwelfth: return self.description + "Need to examine repressed emotions"
                    case .opposition: return self.description + "Stick with plans, efficency; budget time"
                    default: return self.description
                    }
                case .uranus:
                    switch relation {
                    case .conjunction: return self.description + "High hopes, unrealistic plans"
                    case .sextile: return self.description + "Original, inventive, creative"
                    case .square: return self.description + "Erratic or eccentric behavior, quick mind"
                    case .trine: return self.description + "Originality; influence others"
                    case .fiveTwelfth: return self.description + "Abrupt changes in moods unsettle old patterns"
                    case .opposition: return self.description + "Distractions, unvonventional acts or thoughts"
                    default: return self.description
                    }
                case .neptune:
                    switch relation {
                    case .conjunction: return self.description + "Distractions, sensitive emotions"
                    case .sextile: return self.description + "Intuitions, creativity, meditations"
                    case .square: return self.description + "Judgement poor; gullible, impressionable"
                    case .trine: return self.description + "Idealistic, romantic, friendly"
                    case .fiveTwelfth: return self.description + "Discriminate between apathy and relaxation"
                    case .opposition: return self.description + "Distruct intuition, postpone decisions"
                    default: return self.description
                    }
                case .pluto:
                    switch relation {
                    case .conjunction: return self.description + "Involvement with others, quiet conversations"
                    case .sextile: return self.description + "Enlightening descussions, intense feelings"
                    case .square: return self.description + "Make few demands on others and yourself"
                    case .trine: return self.description + "Romance, pleasure, popularity"
                    case .fiveTwelfth: return self.description + "Emotional upheavals threan inner security"
                    case .opposition: return self.description + "Daydreams, snags in plans"
                    default: return self.description
                    }
                default: return self.description
                }
            case .mercury:
                switch secondaryBody {
                case .venus:
                    switch relation {
                    case .conjunction: return self.description + "More artistic and pleasant"
                    case .sextile: return self.description + "Emotional happiness and calm"
                    case .square: return self.description + "Write letters, make phone calls"
                    case .trine: return self.description + "Unexpected meetings, social invitations"
                    case .fiveTwelfth: return self.description + "Misunderstood affection"
                    case .opposition: return self.description + "Meet new people, conversations"
                    default: return self.description
                    }
                case .mars:
                    switch relation {
                    case .conjunction: return self.description + "Ideas abound; impulsive, easy communications"
                    case .sextile: return self.description + "Good sense of humor, social ease"
                    case .square: return self.description + "Touchy; challenge in communications"
                    case .trine: return self.description + "Quick mind; can get your point across"
                    case .fiveTwelfth: return self.description + "Avoid nervous overstrain"
                    case .opposition: return self.description + "Be tactful, could have arguments"
                    default: return self.description
                    }
                case .jupiter:
                    switch relation {
                    case .conjunction: return self.description + "Good news; study; tolerant"
                    case .sextile: return self.description + "Reunions, travel plans, new ideas"
                    case .square: return self.description + "Quick to jump to conclusions"
                    case .trine: return self.description + "Interesting and reqarding work"
                    case .fiveTwelfth: return self.description + "exaggerated ideas cloud judgement"
                    case .opposition: return self.description + "Be practical; the center of everyone's attention"
                    default: return self.description
                    }
                case .saturn:
                    switch relation {
                    case .conjunction: return self.description + "Serious thinking; attention to details"
                    case .sextile: return self.description + "Plan ahead; good judgement"
                    case .square: return self.description + "Be diplomatic, avoid stubbornness"
                    case .trine: return self.description + "Make realistic decisions for your future"
                    case .fiveTwelfth: return self.description + "Laborious thinking impedes communication"
                    case .opposition: return self.description + "Delay in plans, watch what you put into writing"
                    default: return self.description
                    }
                case .uranus:
                    switch relation {
                    case .conjunction: return self.description + "Mind sparks with original ideas"
                    case .sextile: return self.description + "Can find support for your ideas"
                    case .square: return self.description + "Sarcastic; don't worry about things"
                    case .trine: return self.description + "New friends; social life exciting"
                    case .fiveTwelfth: return self.description + "Need to concentrate on one interest at a time"
                    case .opposition: return self.description + "Temperamental; many small irritations"
                    default: return self.description
                    }
                case .neptune:
                    switch relation {
                    case .conjunction: return self.description + "Confused or idealistic thinking"
                    case .sextile: return self.description + "Intuitie awareness, cleverness"
                    case .square: return self.description + "Escapist tendencies, laziness"
                    case .trine: return self.description + "Romantic, idealistic thoughts"
                    case .fiveTwelfth: return self.description + "Healing through creative visualizations"
                    case .opposition: return self.description + "Gossip, scandalous news"
                    default: return self.description
                    }
                case .pluto:
                    switch relation {
                    case .conjunction: return self.description + "Be subtle, not forceful"
                    case .sextile: return self.description + "Get small tasks done quickly"
                    case .square: return self.description + "Minor mistakes, overspending"
                    case .trine: return self.description + "Can gain support for special plan"
                    case .fiveTwelfth: return self.description + "Implusive, outspoken; some quarrels"
                    case .opposition: return self.description + "Careful analysis of psychological imbalances"
                    default: return self.description
                    }
                default: return self.description
                }
            case .venus:
                switch secondaryBody {
                case .mars:
                    switch relation {
                    case .conjunction: return self.description + "Popular; extravagance, love"
                    case .sextile: return self.description + "Can easily express your feelings"
                    case .square: return self.description + "Extravagance with pleasures and luxuries"
                    case .trine: return self.description + "Can put values and beliefs into action"
                    case .fiveTwelfth: return self.description + "Sexual desires need refined expression"
                    case .opposition: return self.description + "Can be imposed on; sensitive feelings"
                    default: return self.description
                    }
                case .jupiter:
                    switch relation {
                    case .conjunction: return self.description + "Life seems happier, more joyful"
                    case .sextile: return self.description + "Friendly to all; lighthearted"
                    case .square: return self.description + "Personal ubset; sensitive feelings"
                    case .trine: return self.description + "You recieve the rewards you deserve"
                    case .fiveTwelfth: return self.description + "Reassessment of a romantic partner"
                    case .opposition: return self.description + "Be practical and realistic in all plans"
                    default: return self.description
                    }
                case .saturn:
                    switch relation {
                    case .conjunction: return self.description + "Make plans for parties and get-togethers"
                    case .sextile: return self.description + "New career opportunities, success"
                    case .square: return self.description + "May be sarcastic with loved ones"
                    case .trine: return self.description + "Sincere, realistic, stable"
                    case .fiveTwelfth: return self.description + "Unconscious scruples upset romantic harmony"
                    case .opposition: return self.description + "Don't compare yourself with others; duty"
                    default: return self.description
                    }
                case .uranus:
                    switch relation {
                    case .conjunction: return self.description + "May be attracted to a new love interest"
                    case .sextile: return self.description + "Peaceful thoughts end arguments"
                    case .square: return self.description + "Excitement in love life"
                    case .trine: return self.description + "Surround yourself with beauty and pleasure"
                    case .fiveTwelfth: return self.description + "Restlessness in a relationship; seeking freedom"
                    case .opposition: return self.description + "Impulsive feelings, changes in mood"
                    default: return self.description
                    }
                case .neptune:
                    switch relation {
                    case .conjunction: return self.description + "Creative, romantic time"
                    case .sextile: return self.description + "Can recieve a cherished hope or wish"
                    case .square: return self.description + "Let your light and your talents shine"
                    case .trine: return self.description + "Redecoration, creativity, daydreaming"
                    case .fiveTwelfth: return self.description + "Express musical inspirations"
                    case .opposition: return self.description + "Impractical idealism, deceptive thoughts"
                    default: return self.description
                    }
                case .pluto:
                    switch relation {
                    case .conjunction: return self.description + "Don't force a commitment from a loved one"
                    case .sextile: return self.description + "Take the initiative, don't sit at home"
                    case .square: return self.description + "May judge others too harshly"
                    case .trine: return self.description + "Romantic happiness, friendships"
                    case .fiveTwelfth: return self.description + "A fading relationship dies"
                    case .opposition: return self.description + "Exciting romance could start"
                    default: return self.description
                    }
                default: return self.description
                }
            case .mars:
                switch secondaryBody {
                case .jupiter:
                    switch relation {
                    case .conjunction: return self.description + "Optimistic, willing to take a chance"
                    case .sextile: return self.description + "Can use your talents to get what you want"
                    case .square: return self.description + "Urge to get away from everything"
                    case .trine: return self.description + "Can make progress at work and home"
                    case .fiveTwelfth: return self.description + "Overly exuberant"
                    case .opposition: return self.description + "Avoid extravagance, add to your security"
                    default: return self.description
                    }
                case .saturn:
                    switch relation {
                    case .conjunction: return self.description + "Tackle all projects that take a lot of energy"
                    case .sextile: return self.description + "Work goes smoothly if preplanned"
                    case .square: return self.description + "Duties may be forced on you by others"
                    case .trine: return self.description + "Good time for reunion with old friends or family"
                    case .fiveTwelfth: return self.description + "Nervous restraint"
                    case .opposition: return self.description + "Nervousness, inability to act"
                    default: return self.description
                    }
                case .uranus:
                    switch relation {
                    case .conjunction: return self.description + "Take it easy, don't get excited"
                    case .sextile: return self.description + "Good with anything you attempt; success"
                    case .square: return self.description + "False starts, accidents, high-strung"
                    case .trine: return self.description + "Think about your future, not your past"
                    case .fiveTwelfth: return self.description + "Rash and impulsive actions"
                    case .opposition: return self.description + "Self-control in thinking and acting needed"
                    default: return self.description
                    }
                case .neptune:
                    switch relation {
                    case .conjunction: return self.description + "Impracticality with money and energy"
                    case .sextile: return self.description + "Changes can lead to excitement"
                    case .square: return self.description + "Laziness, procrastination, religious fanaticism"
                    case .trine: return self.description + "Intuitively know what to do and how to do it"
                    case .fiveTwelfth: return self.description + "Under-energized, delusional dreams"
                    case .opposition: return self.description + "Don't force others to act when you don't"
                    default: return self.description
                    }
                case .pluto:
                    switch relation {
                    case .conjunction: return self.description + "Difficult to handle personal matters"
                    case .sextile: return self.description + "Will be able to tackle any problem"
                    case .square: return self.description + "Not the time to make changes in your life"
                    case .trine: return self.description + "Can clear away the clutter in your life"
                    case .fiveTwelfth: return self.description + "Restlessness and unease; causes unknown"
                    case .opposition: return self.description + "Restlessness; strong desire for changes"
                    default: return self.description
                    }
                default: return self.description
                }
            case .jupiter:
                switch secondaryBody {
                case .saturn:
                    switch relation {
                    case .conjunction: return self.description + "Orderly; prudent expansion toward objectives"
                    case .sextile: return self.description + "Confidence and achievement"
                    case .square: return self.description + "Lack of purpose and faith; Ill-timing"
                    case .trine: return self.description + "Faith in destiny; inspired constructiveness"
                    case .fiveTwelfth: return self.description + "Restlessness and unease"
                    case .opposition: return self.description + "Vacillation and doubt of goals and ambitions"
                    default: return self.description
                    }
                case .uranus:
                    switch relation {
                    case .conjunction: return self.description + "Unexpected good fortune or understanding"
                    case .sextile: return self.description + "New consideration"
                    case .square: return self.description + "Zesty pursuit or unfeasible tangents"
                    case .trine: return self.description + "New and firtuitous insights"
                    case .fiveTwelfth: return self.description + "Distruct of shared values and ideals"
                    case .opposition: return self.description + "Disorienting, sudden developments"
                    default: return self.description
                    }
                case .neptune:
                    switch relation {
                    case .conjunction: return self.description + "Creative and spiritual optimism"
                    case .sextile: return self.description + "Mystical inspiration"
                    case .square: return self.description + "Unsound approach to abstract, mystical ideas"
                    case .trine: return self.description + "Access to universal love and creativity"
                    case .fiveTwelfth: return self.description + "Beliefs overstep ideals"
                    case .opposition: return self.description + "Hold conflicting views about reality and idealism"
                    default: return self.description
                    }
                case .pluto:
                    switch relation {
                    case .conjunction: return self.description + "Efforts at psychological improvement"
                    case .sextile: return self.description + "Interest in spiritual, psychological, occult ideas"
                    case .square: return self.description + "Coercive use of willpower for a \"spiritual\" goal"
                    case .trine: return self.description + "Spiritual, psychological regeneration and growth"
                    case .fiveTwelfth: return self.description + "Conflict between truth and emotions"
                    case .opposition: return self.description + "Gradiose, exploitive schemes that tend to fail"
                    default: return self.description
                    }
                default: return self.description
                }
            case .saturn:
                switch secondaryBody {
                case .uranus:
                    switch relation {
                    case .conjunction: return self.description + "Tension to build; constructive alertness"
                    case .sextile: return self.description + "Limited creative freedom"
                    case .square: return self.description + "Conflict between independence and success"
                    case .trine: return self.description + "Success where others fail; quick insight"
                    case .fiveTwelfth: return self.description + "Uptight about limited independence"
                    case .opposition: return self.description + "Frustrating resistance, non-submission, accidents"
                    default: return self.description
                    }
                case .neptune:
                    switch relation {
                    case .conjunction: return self.description + "Focus on spiritual objectives; mystical cynicism"
                    case .sextile: return self.description + "Spiritual insights further ambitions"
                    case .square: return self.description + "Escape from responsibility; loss of ambition"
                    case .trine: return self.description + "Hidden resources give support"
                    case .fiveTwelfth: return self.description + "Imagination is distrusted"
                    case .opposition: return self.description + "Hidden influences impede material goals"
                    default: return self.description
                    }
                case .pluto:
                    switch relation {
                    case .conjunction: return self.description + "Externalization of psychological realities"
                    case .sextile: return self.description + "Increased self-discipline and moral integrity"
                    case .square: return self.description + "Watch out for dangerous circumstances"
                    case .trine: return self.description + "Willpower to accomplish objectives easily"
                    case .fiveTwelfth: return self.description + "Haunting fear of failure"
                    case .opposition: return self.description + "Coercive suppression by self or others"
                    default: return self.description
                    }
                default: return self.description
                }
            case .uranus:
                switch secondaryBody {
                case .neptune:
                    switch relation {
                    case .conjunction: return self.description + "New mystical, spiritual impressions and feelings"
                    case .sextile: return self.description + "New interests in the spiritual side of life"
                    case .square: return self.description + "Deluded freedom, sudden mistaken impressions"
                    case .trine: return self.description + "Sudden helpful precognitions, imaginations"
                    case .fiveTwelfth: return self.description + "Hidden, revolutionary disturbances"
                    case .opposition: return self.description + "Erratic behavior caused by deluded motivations"
                    default: return self.description
                    }
                case .pluto:
                    switch relation {
                    case .conjunction: return self.description + "Sudden expression of strong emotions"
                    case .sextile: return self.description + "New psychological awareness"
                    case .square: return self.description + "Emotional strife, fanaticism, upsets, disturbance"
                    case .trine: return self.description + "Powerful, helpful release of emotional energy"
                    case .fiveTwelfth: return self.description + "Uncorrdinated energy inputs and outputs"
                    case .opposition: return self.description + "Ideals oppose emotional drive"
                    default: return self.description
                    }
                default: return self.description
                }
            case .neptune:
                switch secondaryBody {
                case .pluto:
                    switch relation {
                    case .conjunction: return self.description + "Imagination and desire unite"
                    case .sextile: return self.description + "Desire to create"
                    case .square: return self.description + "Desire impeded by delusion"
                    case .trine: return self.description + "Spiritual goodwill; help from beyond"
                    case .fiveTwelfth: return self.description + "Deluded drive; emotion oversteps reality"
                    case .opposition: return self.description + "Unconcious conflict"
                    default: return self.description
                    }
                default: return self.description
                }
            default: return self.description
            }
        }
    }
    
}


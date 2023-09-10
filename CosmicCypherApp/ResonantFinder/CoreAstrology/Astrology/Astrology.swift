//
//  CoreAstrology.swift
//  HelmKit
//
//  Created by Jordan Trana on 7/24/18.
//  Copyright © 2018 Jordan Trana. All rights reserved.
//


import SwiftAA
import Darwin

open class CoreAstrology {
    public final class AspectRelation {
        
        public var type:AspectRelationType
        public var nodeDistance:Degree
        
        public enum AspectRelationCategory {
            case ease
            case difficulty
            case creativity
            case improbability
            case transcendance
            case divinity
            case unknown
        }
        
        public var category:AspectRelationCategory {
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
        
        public var isEase:Bool {
            switch type {
            case .conjunction, .sextile, .trine: return true
            default: return false
            }
        }
        public var isDifficult:Bool {
            switch type {
            case .opposition, .square, .semisquare, .bisemisquare: return true
            default: return false
            }
        }
        public var isMagic:Bool {
            switch type {
            case .conjunction, .sextile, .trine: return true
            default: return false
            }
        }
        
        public var orbDistance:Degree {
            return type.degree - abs(nodeDistance)
        }
        
        public var concentration:Double {
            let ratio = 1-(abs(self.orbDistance.value)/self.type.orb.value)
            return Double(ratio)
        }
        
        public init(nodeDistance:Degree, forceWith t: AspectRelationType) {
            self.nodeDistance = nodeDistance
            self.type = t
        }
        
        public init?(nodeDistance:Degree, limitTypes:[AspectRelationType] = AspectRelationType.allCases) {
            self.nodeDistance = nodeDistance
            guard let t = AspectRelationType(nodeDistance: nodeDistance, limitTypes: limitTypes) else {return nil}
            self.type = t
        }
        
        public var defaultDescription:String {
            return type.defaultDescription
        }
    }
    
    public enum AspectRelationType:Double, CaseIterable, Codable {
        
        // init AspectRelationType (based on distance between AspectBodies)
        public init?(nodeDistance:Degree, limitTypes:[AspectRelationType] = AspectRelationType.allCases) {
            print("creating aspect relation for nodeDistance: \(nodeDistance)")
            
            // Setup
            var relationType:AspectRelationType? = nil
            
            // Iterate through all Types
            for thisRelationType in limitTypes {
                print("checking for relationType: \(thisRelationType.symbol)")
                // If type is within orb
                if thisRelationType.withinOrb(nodeDistance: nodeDistance) {
                    print("found relationType: \(thisRelationType.symbol)")
                    relationType = thisRelationType
                    break
                }
            }
            
            // if none found, return nil
            guard let type = relationType else {
                print("no relationType found for nodeDistance: \(nodeDistance)")
                return nil
            }
            
            // Init
            print("init relationType: \(type.symbol)")
            self = type
        }
        
        // init AspectRelationType (based on )
        public init?(distanceFromOrbCenter:Degree, expectedType:AspectRelationType) {
            print("creating aspect relation for distanceFromOrbCenter: \(distanceFromOrbCenter)")
            
            print("checking for relationType: \(expectedType.symbol)")
            // If type is within orb
            if abs(distanceFromOrbCenter) < expectedType.orb {
                print("found relationType: \(expectedType.symbol)")
                self = expectedType
            } else {
                print("relationType \(expectedType.symbol) not within distance (return nil)")
                return nil
            }
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
        
        public var degree:Degree {
            return Degree(self.rawValue)
        }
        
        public func distance(orbitDegreeOffset:Degree) -> Degree {
            return abs(orbitDegreeOffset - self.degree)
        }
        
        public func withinOrb(nodeDistance:Degree) -> Bool {
            let diff = abs(self.degree - nodeDistance)
            let orb = self.orb
            let isWithinOrb = diff < orb
            return isWithinOrb
        }
        
        public var isEasyAspect:Bool {
            switch self {
            case .novile, .binovile, .quadranovile, .oneTwelfth, .sextile, .trine:
                return true
            default:
                return false
            }
        }
        
        public var priority:Double {
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
        
        public var orb:Degree {
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
        
        public var fraction:String {
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
        
        public var symbol:String {
            switch self {
            case .conjunction: return "☌"
            case .opposition: return "☍"
            case .trine: return "△"
            case .square: return "☐"
            case .quintile: return "⭐︎"
            case .biquintile: return "⭐︎²"
            case .sextile: return "✱"
            case .septile: return "7¹"
            case .biseptile: return "7²"
            case .triseptile: return "7³"
            case .semisquare: return "8¹"
            case .bisemisquare: return "8³"
            case .novile: return "9¹"
            case .binovile: return "9²"
            case .quadranovile: return "9⁴"
            case .oneTenth: return "10¹"
            case .threeTenth: return "10³"
            case .oneEleventh: return "11¹"
            case .twoEleventh: return "11²"
            case .threeEleventh: return "11³"
            case .fourEleventh: return "11⁴"
            case .fiveEleventh: return "11⁵"
            case .oneTwelfth: return "12¹"
            case .fiveTwelfth: return "12⁵"
            }
        }
        
        public var imageName:String {
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
        
        public var image:StarKitImage {
            switch self {
            case .conjunction: return StarKitAssets.Images.AspectSymbols.conjunct
            case .opposition: return StarKitAssets.Images.AspectSymbols.opposition
            case .trine: return StarKitAssets.Images.AspectSymbols.trine
            case .square: return StarKitAssets.Images.AspectSymbols.square
            case .quintile, .biquintile: return StarKitAssets.Images.AspectSymbols.fifth
            case .sextile: return StarKitAssets.Images.AspectSymbols.sextile
            case .septile, .biseptile, .triseptile: return StarKitAssets.Images.AspectSymbols.seventh
            case .semisquare, .bisemisquare: return StarKitAssets.Images.AspectSymbols.eighth
            case .novile, .binovile, .quadranovile: return StarKitAssets.Images.AspectSymbols.ninth
            case .oneTenth, .threeTenth: return StarKitAssets.Images.AspectSymbols.tenth
            case .oneEleventh, .twoEleventh, .threeEleventh, .fourEleventh, .fiveEleventh: return StarKitAssets.Images.AspectSymbols.eleventh
            case .oneTwelfth, .fiveTwelfth: return StarKitAssets.Images.AspectSymbols.twelfth
            }
        }
        
        public var defaultDescription:String {
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
    
    public struct AspectBody: Hashable, Equatable {
        
        public let equatorialCoordinates:EquatorialCoordinates
        public let type:NodeType
        
        init(equatorialCoordinates: EquatorialCoordinates, type: NodeType) {
            self.equatorialCoordinates = equatorialCoordinates
            self.type = type
        }
        
        init?(type: NodeType, date:Date) {
            guard let equatorialCoordinates = type.equatorialCoordinates(date: date) else {
                return nil
            }
            self.type = type
            self.equatorialCoordinates = equatorialCoordinates
        }
        
        public static func == (lhs: CoreAstrology.AspectBody, rhs: CoreAstrology.AspectBody) -> Bool {
            return lhs.type == rhs.type && lhs.equatorialCoordinates.alpha == rhs.equatorialCoordinates.alpha && lhs.equatorialCoordinates.delta == rhs.equatorialCoordinates.delta
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(type)
            hasher.combine(equatorialCoordinates.alpha)
            hasher.combine(equatorialCoordinates.delta)
        }
        
        public func positionAngle(relativeTo secondBody:AspectBody) -> Degree {
            equatorialCoordinates.positionAngle(relativeTo: secondBody.equatorialCoordinates)
        }
        
        public func longitudeDifference(from secondBody:AspectBody, on date:Date) -> Degree? {
            guard let l1 = self.type.geocentricLongitude(date: date),
                  let l2 = secondBody.type.geocentricLongitude(date: date) else {
                return nil
            }
            return l1 - l2
        }
        
        public enum NodeType: Int, CaseIterable {
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
            
            public init?(with planet:PlanetaryBase) {
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
            
            public var text: String {
                switch self {
                case .sun: return "Sun"
                case .moon: return "Moon"
                case .mercury: return "Mercury"
                case .venus: return "Venus"
                case .mars: return "Mars"
                case .jupiter: return "Jupiter"
                case .saturn: return "Saturn"
                case .uranus: return "Uranus"
                case .neptune: return "Neptune"
                case .pluto: return "Pluto"
                case .ascendant: return "Ascendant"
                case .decendant: return "Decendant"
                case .midheaven: return "Mid Heaven"
                case .imumCoeli: return "Imum Coeli"
                case .lunarAscendingNode: return "North Lunar Node"
                case .lunarDecendingNode: return "South Lunar Node"
                case .lunarApogee: return "Apogee Lunar Node"
                case .lunarPerigee: return "Perigee Lunar Node"
                case .partOfFortune: return "Fortune Part"
                case .partOfSpirit: return "Spirit Part"
                case .partOfEros: return "Eros Part"
                }
            }
            
            public var imageName:String {
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
            
            public var fileNameSuffix:String {
                switch self {
                case .moon: return "moon"
                case .sun: return "sun"
                case .mercury: return "mercury"
                case .venus: return "venus"
                case .mars: return "mars"
                case .jupiter: return "jupiter"
                case .saturn: return "saturn"
                case .uranus: return "uranus"
                case .neptune: return "neptune"
                case .pluto: return "pluto"
                case .ascendant: return "asc"
                case .decendant: return "dec"
                case .midheaven: return "mc"
                case .imumCoeli: return "ic"
                case .lunarAscendingNode: return "moon_asc"
                case .lunarDecendingNode: return "moon_dec"
                case .lunarApogee: return "moon_apogee"
                case .lunarPerigee: return "moon_perigee"
                case .partOfFortune: return "pt_fortune"
                case .partOfSpirit: return "pt_spirit"
                case .partOfEros: return "pt_eros"
                }
            }
            
            public var image:StarKitImage? {
                return StarKitImage(named: imageName)
            }
            
            public var symbol:String {
                switch self {
                case .sun: return "☉"
                case .moon: return "☽"
                case .mercury: return "☿"
                case .venus: return "♀"
                case .mars: return "♂︎"
                case .jupiter: return "♃"
                case .saturn: return "♄"
                case .uranus: return "♅"
                case .neptune: return "♆"
                case .pluto: return "♇"
                case .ascendant: return "Asc"
                case .decendant: return "Dec"
                case .midheaven: return "MH"
                case .imumCoeli: return "IC"
                case .lunarAscendingNode: return "☊"
                case .lunarDecendingNode: return "☋"
                case .lunarApogee: return "⚸"
                case .lunarPerigee: return "-⚸"
                case .partOfFortune: return "Ⓧ"
                case .partOfSpirit: return "꩜"
                case .partOfEros: return "♡"
                }
            }
            
            public var defaultDescription:String {
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
            
            public var hasGravity:Bool {
                switch self {
                    case .moon, .sun, .mercury, .venus, .mars, .jupiter, .saturn, .uranus, .neptune: return true
                default: return false
                }
            }
            
            public static var bodiesWithGravity:[AspectBody.NodeType] = [.moon,
                                                         .sun,
                                                         .mercury,
                                                         .venus,
                                                         .mars,
                                                         .jupiter,
                                                         .saturn,
                                                         .uranus,
                                                         .neptune]
            
            public func generatePlanetState(date:Date, highPrecision:Bool = true) -> PlanetState? {
                if let planet: Planet = planet(date: date, highPrecision: highPrecision) {
                    let planetState = PlanetState(nodeType: self,
                                                  date: date,
                                                  degrees: planet.equatorialCoordinates.alpha.inDegrees.value,
                                                  perihelion: planet.perihelion.value,
                                                  ascendingNode: planet.longitudeOfAscendingNode().value,
                                                  inclination: planet.inclination().value,
                                                  eccentricity: planet.eccentricity())
                    return planetState
                }
                return nil
            }
            
            public func planet(starChart: StarChart, highPrecision:Bool = true) -> Planet? {
                let julianDay = JulianDay(starChart.date)
                switch self {
                case .mercury: return Mercury(julianDay: julianDay, highPrecision: highPrecision)
                case .venus: return Venus(julianDay: julianDay, highPrecision: highPrecision)
                case .mars: return Mars(julianDay: julianDay, highPrecision: highPrecision)
                case .jupiter: return Jupiter(julianDay: julianDay, highPrecision: highPrecision)
                case .saturn: return Saturn(julianDay: julianDay, highPrecision: highPrecision)
                case .uranus: return Uranus(julianDay: julianDay, highPrecision: highPrecision)
                case .neptune: return Neptune(julianDay: julianDay, highPrecision: highPrecision)
                default: return nil
                }
                
            }
            
            public func planet(date:Date, highPrecision:Bool = true) -> Planet? {
                let julianDay = JulianDay(date)
                switch self {
                case .mercury: return Mercury(julianDay: julianDay, highPrecision: highPrecision)
                case .venus: return Venus(julianDay: julianDay, highPrecision: highPrecision)
                case .mars: return Mars(julianDay: julianDay, highPrecision: highPrecision)
                case .jupiter: return Jupiter(julianDay: julianDay, highPrecision: highPrecision)
                case .saturn: return Saturn(julianDay: julianDay, highPrecision: highPrecision)
                case .uranus: return Uranus(julianDay: julianDay, highPrecision: highPrecision)
                case .neptune: return Neptune(julianDay: julianDay, highPrecision: highPrecision)
                default: return nil
                }
                
            }
            
            public func planetaryOrbit(date:Date, highPrecision:Bool = true) -> PlanetaryOrbits? {
                let julianDay = JulianDay(date)
                switch self {
                case .mercury: return Mercury(julianDay: julianDay, highPrecision: highPrecision)
                case .venus: return Venus(julianDay: julianDay, highPrecision: highPrecision)
                case .mars: return Mars(julianDay: julianDay, highPrecision: highPrecision)
                case .jupiter: return Jupiter(julianDay: julianDay, highPrecision: highPrecision)
                case .saturn: return Saturn(julianDay: julianDay, highPrecision: highPrecision)
                case .uranus: return Uranus(julianDay: julianDay, highPrecision: highPrecision)
                case .neptune: return Neptune(julianDay: julianDay, highPrecision: highPrecision)
                case .pluto: return Pluto(julianDay: julianDay, highPrecision: highPrecision)
                default: return nil
                }
                
            }

            public func equatorialCoordinates(date:Date, highPrecision:Bool = true) -> EquatorialCoordinates? {
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
                default: return nil
                }
            }
            
            public func ascendingNode(planetaryOrbit: PlanetaryOrbits) -> Degree {
                return planetaryOrbit.longitudeOfAscendingNode()
            }
            
            public func rise(date:Date, highPrecision:Bool = true) -> Degree? {
                let julianDay = JulianDay(date)
                switch self {
                case .sun: return Earth(julianDay: julianDay, highPrecision: highPrecision).longitudeOfAscendingNode()
                case .moon: return Moon(julianDay: julianDay, highPrecision: highPrecision).longitudeOfTrueAscendingNode
                case .mercury: return Mercury(julianDay: julianDay, highPrecision: highPrecision).longitudeOfAscendingNode()
                case .venus: return Venus(julianDay: julianDay, highPrecision: highPrecision).longitudeOfAscendingNode()
                case .mars: return Mars(julianDay: julianDay, highPrecision: highPrecision).longitudeOfAscendingNode()
                case .jupiter: return Jupiter(julianDay: julianDay, highPrecision: highPrecision).longitudeOfAscendingNode()
                case .saturn: return Saturn(julianDay: julianDay, highPrecision: highPrecision).longitudeOfAscendingNode()
                case .uranus: return Uranus(julianDay: julianDay, highPrecision: highPrecision).longitudeOfAscendingNode()
                case .neptune: return Neptune(julianDay: julianDay, highPrecision: highPrecision).longitudeOfAscendingNode()
                case .pluto: return Pluto(julianDay: julianDay, highPrecision: highPrecision).longitudeOfAscendingNode()
                default: return nil
                }
            }
            
            public func exaltation(date:Date, highPrecision:Bool = true) -> Degree? {
                let julianDay = JulianDay(date)
                switch self {
                case .sun: return Earth(julianDay: julianDay, highPrecision: highPrecision).longitudeOfPerihelion()
                case .moon: return Moon(julianDay: julianDay, highPrecision: highPrecision).longitudeOfMeanPerigee
                case .mercury: return Mercury(julianDay: julianDay, highPrecision: highPrecision).longitudeOfPerihelion()
                case .venus: return Venus(julianDay: julianDay, highPrecision: highPrecision).longitudeOfPerihelion()
                case .mars: return Mars(julianDay: julianDay, highPrecision: highPrecision).longitudeOfPerihelion()
                case .jupiter: return Jupiter(julianDay: julianDay, highPrecision: highPrecision).longitudeOfPerihelion()
                case .saturn: return Saturn(julianDay: julianDay, highPrecision: highPrecision).longitudeOfPerihelion()
                case .uranus: return Uranus(julianDay: julianDay, highPrecision: highPrecision).longitudeOfPerihelion()
                case .neptune: return Neptune(julianDay: julianDay, highPrecision: highPrecision).longitudeOfPerihelion()
                case .pluto: return Pluto(julianDay: julianDay, highPrecision: highPrecision).longitudeOfPerihelion()
                default: return nil
                }
            }

            public func geocentricLongitude(date:Date, coords:GeographicCoordinates = GeographicCoordinates(positivelyWestwardLongitude: 0, latitude: 0), highPrecision:Bool = true) -> Degree? {
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
                case .pluto: return Pluto(julianDay: julianDay, highPrecision: highPrecision).meanLongitude()//.apparentGeocentricEquatorialCoordinates.alpha.inDegrees
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
            
            public func distanceFromEarth(date:Date, highPrecision:Bool = true) -> AstronomicalUnit? {
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
            
            public func massOfPlanet() -> Kilogram? {
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
            
            
            public func planetaryDetails(date:Date, highPrecision:Bool = true) -> PlanetaryDetails? {
                let julianDay = JulianDay(date)
                switch self {
                case .mercury: return Mercury(julianDay: julianDay, highPrecision: highPrecision)
                case .venus: return Venus(julianDay: julianDay, highPrecision: highPrecision)
                case .mars: return Mars(julianDay: julianDay, highPrecision: highPrecision)
                case .jupiter: return Jupiter(julianDay: julianDay, highPrecision: highPrecision)
                case .saturn: return Saturn(julianDay: julianDay, highPrecision: highPrecision)
                case .uranus: return Uranus(julianDay: julianDay, highPrecision: highPrecision)
                case .neptune: return Neptune(julianDay: julianDay, highPrecision: highPrecision)
                default: return nil
                }
            }
            
            public func celestialBody(date:Date, highPrecision:Bool = true) -> CelestialBody? {
                let julianDay = JulianDay(date)
                switch self {
                case .sun: return Sun(julianDay: julianDay, highPrecision: highPrecision)
                case .moon: return Moon(julianDay: julianDay, highPrecision: highPrecision)
                case .mercury: return Mercury(julianDay: julianDay, highPrecision: highPrecision)
                case .venus: return Venus(julianDay: julianDay, highPrecision: highPrecision)
                case .mars: return Mars(julianDay: julianDay, highPrecision: highPrecision)
                case .jupiter: return Jupiter(julianDay: julianDay, highPrecision: highPrecision)
                case .saturn: return Saturn(julianDay: julianDay, highPrecision: highPrecision)
                case .uranus: return Uranus(julianDay: julianDay, highPrecision: highPrecision)
                case .neptune: return Neptune(julianDay: julianDay, highPrecision: highPrecision)
                default: return nil
                }
            }
            
            public func radiusVector(date:Date, highPrecision:Bool = true) -> AstronomicalUnit? {
                return self.planetaryDetails(date: date, highPrecision: highPrecision)?.radiusVector ?? self.celestialBody(date: date, highPrecision: highPrecision)?.radiusVector
            }
            
            // Distance between This Planet and Another Planet
            public func distance(from otherPlanet:NodeType, date:Date, highPrecision:Bool = true) -> AstronomicalUnit? {
                
                guard let planet1 = self.planet(date: date) else {return nil}
                guard let planet2 = otherPlanet.planet(date: date) else {return nil}
                
                /// Guard for Radius Vectors (required for trig)
                guard let a:Double = self.radiusVector(date: date, highPrecision: highPrecision)?.value,
                      let b:Double = otherPlanet.radiusVector(date: date, highPrecision: highPrecision)?.value else {
                          return nil
                      }
                
                /// Catch for Basic Values
                switch self {
                case .sun:
                    switch otherPlanet {
                    case .sun: return 0
                    default: return AstronomicalUnit(b)
                    }
                default:
                    switch otherPlanet {
                    case .sun: return AstronomicalUnit(a)
                    default: ()
                    }
                }
                
                /// Trig Values (distances and angles)
                let p1_HeliocentricAngle = planet1.heliocentricEclipticCoordinates.celestialLongitude.value //self.heliocentricPosition().value
                let p2_HeliocentricAngle = planet2.heliocentricEclipticCoordinates.celestialLongitude.value //otherPlanet.heliocentricPosition().value
                
                /// Trig (Trigonometry) 📐
                var C:Double = Double(p2_HeliocentricAngle - p1_HeliocentricAngle)
                C = (C + 180).truncatingRemainder(dividingBy: 360) - 180
                let c:Double = sqrt(((a*a)+(b*b))-(2*a*b*cos(C)))
                
                /// Distance between the two Planets
                return AstronomicalUnit(c)
            }
            
            public func gravimetricForceBetween(otherPlanet:NodeType, date: Date) -> Double? {
                guard let p1mass = massOfPlanet(),
                      let p2mass = otherPlanet.massOfPlanet(),
                      let distanceInMeters = self.distance(from: otherPlanet, date: date)?.value else {
                        return nil
                }
                let universalGravityConstant:Double = 6.673e-11
                return (universalGravityConstant*p1mass*p2mass)/(distanceInMeters*distanceInMeters)
            }
            
            public func gravimetricForceOnSun(date:Date) -> Double? {
                return gravimetricForceBetween(otherPlanet: .sun, date: date)
            }
            
            public func gravimetricForceOnEarth(date:Date) -> Double? {
                guard let mass = massOfPlanet(),
                    let distanceInMeters = distanceFromEarth(date: date)?.inMeters.value else {
                        return nil
                }
                let earthMass:Kilogram = 5.97237e24
                let universalGravityConstant:Double = 6.673e-11
                return (universalGravityConstant*earthMass*mass)/(distanceInMeters*distanceInMeters)
            }
            
            public func gravimetricForce(on geographicCoordinate:GeographicCoordinates, date:Date) -> Double? {
                guard let mass = massOfPlanet(),
                    let distanceInMeters = distanceFromEarth(date: date)?.inMeters.value else {
                        return nil
                }
                let earthMass:Kilogram = 5.97237e24
                let universalGravityConstant:Double = 6.673e-11
                return (universalGravityConstant*earthMass*mass)/(distanceInMeters*distanceInMeters)
            }
            
            public func geocentricNormalVector(date:Date) -> Vector3 {
                guard let coords = equatorialCoordinates(date: date) else { return Vector3.empty }
                
                let phi   = (90.0-coords.alpha.inDegrees.value)*(Double.pi/180);
                let theta = (coords.delta.value+180.0)*(Double.pi/180);

                let x = (sin(phi)*cos(theta));
                let z = (sin(phi)*sin(theta));
                let y = (cos(phi));
                
                return Vector3(x,y,z)
            }
            
            public func heliocentricNormalVector(date:Date) -> Vector3 {
                guard let coords = equatorialCoordinates(date: date) else { return Vector3.empty }
                
                let phi   = (90.0-coords.alpha.inDegrees.value)*(Double.pi/180);
                let theta = (coords.delta.value+180.0)*(Double.pi/180);

                let x = (sin(phi)*cos(theta));
                let z = (sin(phi)*sin(theta));
                let y = (cos(phi));
                
                return Vector3(x,y,z)
            }
            
            public func geocentricGravimetricTensor(date:Date) -> GravimetricTensor {
                guard let magnitude = gravimetricForceOnEarth(date: date) else { return .empty }
                let vectorNormal = geocentricNormalVector(date: date)
                return GravimetricTensor(vectorNormal: vectorNormal, magnitude: magnitude)
            }
            
            public func heliocentricGravimetricTensor(date:Date) -> GravimetricTensor {
                guard let magnitude = gravimetricForceOnEarth(date: date) else { return .empty }
                let vectorNormal = heliocentricNormalVector(date: date)
                return GravimetricTensor(vectorNormal: vectorNormal, magnitude: magnitude)
            }
        }
    }
    
    
    
    public struct Vector3 {
        let x:Double
        let y:Double
        let z:Double
        
        public init(_ x:Double, _ y:Double, _ z:Double) {
            self.x = x
            self.y = y
            self.z = z
        }
        
        public static var empty:Vector3 {
            return Vector3(0, 0, 0)
        }
    }
    
    public struct GravimetricTensor {
        
        enum Orientation {
            case geocentric /// Earth Planet Core
            case heliocentric /// Sun Stellar Core
            case centerMass  /// Solar Interplanetary Web
        }
        
        var x:Double
        var y:Double
        var z:Double
        
        public init(vectorNormal: Vector3, magnitude:Double) {
            x = vectorNormal.x * magnitude
            y = vectorNormal.y * magnitude
            z = vectorNormal.z * magnitude
        }
        
        public var magnitude:Double {
            return x + y + z
        }
        
        public static var empty:GravimetricTensor {
            return GravimetricTensor(vectorNormal: Vector3.empty, magnitude:0)
        }
    }
    
    public struct AspectType: Equatable {
        public typealias SymbolHash = String
        
        public var primaryBodyType:AspectBody.NodeType
        public var relationType:AspectRelationType
        public var secondaryBodyType:AspectBody.NodeType
        
        public var hash:SymbolHash {
            return "\(primaryBodyType.symbol) \(relationType.symbol) \(secondaryBodyType.symbol)"
        }
        
        public func aspectEvent(for date:Date) -> AspectEvent? {
            guard let aspect = aspect(for: date) else { return nil }
            return AspectEvent(aspect: aspect, date: date)
        }
        
        public func aspect(for date:Date) -> Aspect? {
            print("creating aspect for: \(hash)")
            guard let b1 = AspectBody(type: primaryBodyType, date: date),
                  let b2 = AspectBody(type: secondaryBodyType, date: date),
                  let d = b1.longitudeDifference(from: b2, on: date),
                  let r = AspectRelation(nodeDistance: d, limitTypes: [relationType]) else { return nil }
            print("using b1(\(b1.type.symbol)) b2(\(b2.type.symbol)) r(\(r.type.symbol))")
            let aspect = Aspect(primaryBody: b1, relation: r, secondaryBody: b2)
            print("created aspect: \(aspect.hash)")
            return aspect
        }
    }
    
    public struct AspectEvent {
        public var aspect:Aspect
        public var date:Date
    }
    
    public final class Aspect {
        // properties
        public var relation:AspectRelation
        public var primaryBody:AspectBody
        public var secondaryBody:AspectBody
        
        // accessors
        public var type:AspectType { return AspectType(primaryBodyType: primaryBody.type, relationType: relation.type, secondaryBodyType: secondaryBody.type) }
        public var hash:AspectType.SymbolHash { return type.hash }
        
        // init
        public init(primaryBody:AspectBody, relation:AspectRelation, secondaryBody:AspectBody) {
            self.primaryBody = primaryBody
            self.secondaryBody = secondaryBody
            self.relation = relation
        }
        
        // init from AspectType and Date
        public init?(type:AspectType, date:Date) {
            guard let b1 = AspectBody(type: type.primaryBodyType, date: date),
                  let b2 = AspectBody(type: type.secondaryBodyType, date: date),
                  let d = b1.longitudeDifference(from: b2, on: date),
                  let r = AspectRelation(nodeDistance: d) else { return nil }
            self.primaryBody = b1
            self.secondaryBody = b2
            self.relation = r
        }
        
        public func longitudeDifference(for date:Date) -> Degree? {
            return primaryBody.longitudeDifference(from: secondaryBody, on: date)
        }
        
        public var positionAngle:Degree {
            return primaryBody.positionAngle(relativeTo: secondaryBody)
        }
        
        public var concentration:Double? {
            return self.relation.concentration
        }
        
        public var combinedDescription:String {
            let description = self.description
            let planetaryEffectDescription = self.planetaryEffectDescription()
            if description.count == planetaryEffectDescription.count {
                return self.planetaryEffectDescription(flipPlanets: true)
            }
            return planetaryEffectDescription
        }
        
        public func shouldRemove(comparedTo other:CoreAstrology.Aspect) -> Bool {
            if relation.type == other.relation.type && primaryBody == other.secondaryBody && secondaryBody == other.primaryBody {
                return primaryBody.type.rawValue > other.primaryBody.type.rawValue
            }
            return false
        }
        
        public func angleDiff(for date:Date, coords:GeographicCoordinates, magnitude:Bool = true) -> Degree? {
            let d = self.primaryBody.equatorialCoordinates.alpha.inDegrees - self.secondaryBody.equatorialCoordinates.alpha.inDegrees
            return magnitude ? abs(d) : d
        }
        
        public var description:String {
            return primaryBody.type.defaultDescription + relation.defaultDescription + secondaryBody.type.defaultDescription
        }
        
        public func planetaryEffectDescription(flipPlanets:Bool = false) -> String {
            
            let relation = self.relation.type
            let primarybody = flipPlanets ? self.secondaryBody.type : self.primaryBody.type
            let secondaryBody = flipPlanets ? self.primaryBody.type : self.secondaryBody.type
            
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

func +=(left: inout CoreAstrology.GravimetricTensor, right: CoreAstrology.GravimetricTensor) {
    left.x += right.x
    left.y += right.y
    left.z += right.z
    left.x += right.x
}

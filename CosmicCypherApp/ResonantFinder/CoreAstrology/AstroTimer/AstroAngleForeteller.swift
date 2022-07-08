//
//  AstroAngleForeteller.swift
//  HelmKit
//
//  Created by Jordan Trana on 8/1/18.
//  Copyright © 2018 Jordan Trana. All rights reserved.
//

import SwiftAA


// This class is built to Foretell the next (or previous)
// acruaccy within 0.01 seconds

// First version is merely iterative, and just trys to calculate a close-enough

public class AstroAngleForeteller {
    
    public enum ResonanceType {
        case power // 1/1
        case bonds // 1/2
        case harmony // 1/3
        case change // 1/4
        case style // 1/5
        case ease // 1/6
        case ideals // 1/7
        case strive // 1/8
        case joy // 1/9
        case help // 1/12
        case adjustment // 5/12
        
        public func emoji() -> String {
            switch self {
            case .power: return "🤩"
            case .bonds: return "😘"
            case .harmony: return "😁"
            case .change: return "😤"
            case .style: return "😎"
            case .ease: return "☺️"
            case .ideals: return "😇"
            case .strive: return "😠"
            case .joy: return "🥳"
            case .help: return "🤗"
            case .adjustment: return "😒"
            }
        }
            
        public func name() -> String {
            switch self {
            case .power: return "Power"
            case .bonds: return "Balance"
            case .harmony: return "Harmony"
            case .change: return "Change"
            case .style: return "Style"
            case .ease: return "Ease"
            case .ideals: return "Ideals"
            case .strive: return "Strive"
            case .joy: return "Joy"
            case .help: return "Help"
            case .adjustment: return "Adjustment"
            }
        }
            
        public static func create(from aspect:CoreAstrology.Aspect) -> ResonanceType? {
            switch aspect.relation.type {
            case .conjunction: return .power
            case .opposition: return .bonds
            case .trine: return .harmony
            case .square: return .change
            case .quintile, .biquintile: return .style
            case .sextile: return .ease
            case .septile, .biseptile, .triseptile: return .ideals
            case .semisquare, .bisemisquare: return .strive
            case .novile, .binovile, .quadranovile: return .joy
            case .oneTwelfth: return .help
            case .fiveTwelfth: return .adjustment
            default: return nil
            }
        }
    }
    
    public struct AspectResult {
        
        public static let threshold:Double = 1
        public static let extreme:Double = 0.001
        
        public let aspect:CoreAstrology.Aspect
        public var angleSeparation:Degree
        
        public var isExtreme:Bool {
            return angleSeparation.value < AspectResult.extreme
        }
        
        public var safeAngleSeparation:Degree {
            return Degree(max(abs(angleSeparation.value), AspectResult.extreme))
        }
        
        public var powerLevel:Double {
            let orb = aspect.relation.type.orb.value
            return Double((orb - safeAngleSeparation.value) / orb)
        }
        
        public var resonanceScore:Double {
            // Depending on the Planet Combination and type of Aspects, Resonances may go negative
            let planetaryAdjustment = AspectResult.threshold
            let score = (planetaryAdjustment + (1 - planetaryAdjustment) * powerLevel)
            return score
        }
        
        public var isSignificant:Bool {
            return resonanceScore > AspectResult.threshold
        }
        
        public var resonanceType:ResonanceType? {
            return ResonanceType.create(from: aspect)
        }
        
    }
    
    public struct AstrologicalReport {
        public let date:Date
        public let coordinates:[CoreAstrology.AspectBody.NodeType:EquatorialCoordinates]
        public let aspectResults:[AspectResult]
        
        public init(date:Date) {
            self.date = date
            let julianDay = JulianDay(date)
            coordinates = [.sun:Sun(julianDay: julianDay).equatorialCoordinates,
            .moon:Moon(julianDay: julianDay).equatorialCoordinates,
            .mercury:Mercury(julianDay: julianDay).equatorialCoordinates,
                           .venus:Venus(julianDay: julianDay).equatorialCoordinates,
            .mars:Mars(julianDay: julianDay).equatorialCoordinates,
            .jupiter:Jupiter(julianDay: julianDay).equatorialCoordinates,
            .saturn:Saturn(julianDay: julianDay).equatorialCoordinates,
            .uranus:Uranus(julianDay: julianDay).equatorialCoordinates,
            .neptune:Neptune(julianDay: julianDay).equatorialCoordinates,
            .pluto:Pluto(julianDay: julianDay).apparentGeocentricEquatorialCoordinates]
            aspectResults = AstrologicalReport.createAspectList(from: coordinates)
        }
        
        public func coordinate(for aspectBody:CoreAstrology.AspectBody.NodeType) -> EquatorialCoordinates? {
            return coordinates[aspectBody]
        }
        
        public static func createAspectList(from coordinates:[CoreAstrology.AspectBody.NodeType:EquatorialCoordinates], getAll:Bool = false) -> [AspectResult] {
            
            var aspectList:[AspectResult] = []
            
            for (aspectBody1, equatorialCoordinate1) in coordinates {
                for (aspectBody2, equatorialCoordinate2) in coordinates {
                    let angularSeparation = equatorialCoordinate1.angularSeparation(with: equatorialCoordinate2)
                    let relation = AstroUtils.closestAspectRelation(for: angularSeparation)
                    let primaryBody = CoreAstrology.AspectBody(equatorialCoordinates: equatorialCoordinate1, type: aspectBody1)
                    let secondaryBody = CoreAstrology.AspectBody(equatorialCoordinates: equatorialCoordinate2, type: aspectBody2)
                    let aspectResult = AspectResult(aspect: CoreAstrology.Aspect(primarybody: primaryBody,
                                                                                 relation: relation,
                                                                                 secondaryBody: secondaryBody), angleSeparation: angularSeparation)
                    if aspectResult.isSignificant || getAll {
                        aspectList.append(aspectResult)
                    }
                }
            }
            return aspectList
        }
    }
    
    public struct AstroAngleReport {
        let afterDate:Date
        let aspects:[Date:CoreAstrology.Aspect]
    }
    
    public static let DEFAULT_ACCURACY:TimeInterval = (1/1000) // Down to milliseconds of accuracy
    public static let DEFAULT_INACCURACY:TimeInterval = 0.5
    
    public static func getFullReport(_ afterDate: Date) -> AstroAngleReport {
        
        var aspects:[Date:CoreAstrology.Aspect] = [:]
        
        for primaryBodyType in CoreAstrology.AspectBody.NodeType.allCases {
            for type in CoreAstrology.AspectRelationType.allCases {
                for secondaryBodyType in CoreAstrology.AspectBody.NodeType.allCases where primaryBodyType != secondaryBodyType {
                    guard let primaryBody = CoreAstrology.AspectBody(type: primaryBodyType, date: afterDate),
                          let secondaryBody = CoreAstrology.AspectBody(type: secondaryBodyType, date: afterDate) else {
                              continue
                          }
                    let relation = CoreAstrology.AspectRelation(degrees: 0, forceWith: type)
                    let aspect = CoreAstrology.Aspect(primarybody: primaryBody,
                                                      relation: relation,
                                                      secondaryBody: secondaryBody)
                    let date = AstroAngleForeteller.whenIsTheDateOfThisNextAspectAlignment(after: afterDate, aspect: aspect)
                    aspects[date] = aspect
                }
            }
        }
        
        return AstroAngleReport(afterDate: afterDate, aspects: aspects)
    }
    
    // This methods does the calculation and returns on a callback... cause this may take a couple iterations: a lot
    public static func whenIsTheDateOfThisNextAspectAlignment(after today:Date, aspect:CoreAstrology.Aspect, accuracy:TimeInterval = DEFAULT_ACCURACY) -> Date {
        p1TotalAngleTravel = 0
        startDate = today
        return getDateNextCloser(from: today, aspect: aspect, accuracy: accuracy)
    }
    
    private static var p1LastLong:Degree?
    private static var p2LastLong:Degree?
    private static var p1DegreeBuffer:Degree = 0
    private static var p2DegreeBuffer:Degree = 0
    private static var p1TotalAngleTravel:Degree = 0
    private static var startDate:Date?
    
    private static func getDateNextCloser(from date:Date, aspect:CoreAstrology.Aspect, accuracy:TimeInterval = DEFAULT_ACCURACY, _  i:Int = 0) -> Date {
        let p1Long = aspect.primaryBody.type.celestialLongitude(date)!
        let p2Long = aspect.secondaryBody.type.celestialLongitude(date)!
        
        //((p1Long + p1DegreeBuffer) - (p2Long + p2DegreeBuffer))
        let thisAngleDiff:Degree = abs(abs(p1Long - p2Long) - aspect.relation.type.degree)
        aspect.relation.degrees = thisAngleDiff
        
        p1LastLong = p1Long
        p2LastLong = p2Long
        
        p1TotalAngleTravel += abs(thisAngleDiff)
        
        //if thisAngleDiff < 0 { thisAngleDiff += 360 }
        
        let timeUntilArrival = abs(TimeInterval((thisAngleDiff.value/360.0))*(aspect.primaryBody.type.orbitPeriodInSeconds() * DEFAULT_INACCURACY))
        let newDate = date.addingTimeInterval(timeUntilArrival)
        
        let df = DateFormatter()
        df.dateFormat = "y-MM-dd H:m:ss.SSSS"
        
        if p1Long + thisAngleDiff > 360 { p1DegreeBuffer += 360 }
        if p2Long + thisAngleDiff > 360 { p2DegreeBuffer += 360 }
        
        if timeUntilArrival < accuracy || i > 500 || p1TotalAngleTravel > 720 {
            if p1TotalAngleTravel > 720 { print("OVER ANGLE: MALFUNCTION") }
            return newDate
        } else {
            return getDateNextCloser(from: newDate, aspect: aspect, i+1)
        }
    }
}

//
//  AstroUtils.swift
//  HelmKit
//
//  Created by Jordan Trana on 7/28/18.
//  Copyright © 2018 Jordan Trana. All rights reserved.
//

import Foundation
import SwiftAA


public struct AstroUtils {
    
    /// Get Closest Date for Aspect realtive to Date
    
    public static let astrologyPlanets:[CoreAstrology.AspectBody.NodeType] = [.mercury,
                                                     .venus,
                                                     .mars,
                                                     .jupiter,
                                                     .saturn,
                                                     .uranus,
                                                     .neptune,
                                                     .pluto]
    
//    public static func getNextAspectsBetweenMoonAndPlanets(date:Date, coords:GeographicCoordinates, useOrbRange:Bool = true) -> [AstroAspectTimeReport] {
//        var reports:[AstroAspectTimeReport] = []
//
//        for planet in astrologyPlanets {
//            if let report = getClosestAspectForMoon(with: planet, date:date, coords:coords) {
//                guard !useOrbRange || report.withinRange else {  continue }
//                reports.append(report)
//            }
//        }
//        
//        return reports
//    }
    
//    // if returns nil that means none within timeRange
//    public static func getClosestAspectForMoon(closeTo date:Date) -> AstroAspectTimeReport? {
//
//        let moonCurrentAngle = CoreAstronomy.moonPhaseAngle()
//        let relation = closestAspectRelationForAngle(angle: moonCurrentAngle)
//        let primarybody = CoreAstrology.AspectBody(type: .moon, date: date)//CoreAstrology.AspectBody.NodeType.moon.equatorialCoordinates(date: date)
//        let secondaryBody  = CoreAstrology.AspectBody.NodeType.sun.equatorialCoordinates(date: date)
//
//        let aspect = CoreAstrology.Aspect(primarybody: primarybody,
//                                          relation: closestAspectRelationForAngle(angle: moonCurrentAngle),
//                                          secondaryBody: secondaryBody)
//        return AstroAspectTimeReport(date: date, aspect: aspect, distance: relation.degrees)
//    }
//
//    public static func getClosestAspectForMoon(with planet:CoreAstrology.AspectBody.NodeType, date:Date, coords:GeographicCoordinates) -> AstroAspectTimeReport? {
//
//        let moonPhaseAngle = CoreAstronomy.moonPhaseAngle()
//        guard let planetPhaseAngle = planet.geocentricLongitude(date: date, coords: coords) else {
//            return nil
//        }
//        let relation = closestAspectRelationForAngle(angle: moonPhaseAngle - planetPhaseAngle)
//
//        let orbitPeriod = planet.orbitPeriodInSeconds()
//        let secondsUntil:TimeInterval = TimeInterval(relation.degrees.value/360.0)*orbitPeriod
//        let date = Date(timeIntervalSinceNow: secondsUntil)
//        let primarybody = CoreAstrology.AspectBody.NodeType.moon.equatorialCoordinates(date: date)
//        let secondaryBody  = CoreAstrology.AspectBody.NodeType.sun.equatorialCoordinates(date: date)
//
//        let aspect = CoreAstrology.Aspect(primarybody: primarybody, relation: relation, secondaryBody: secondaryBody)
//        return AstroAspectTimeReport(date: date, aspect: aspect, distance: relation.degrees)
//    }
    
    public static func closestAspectRelationForAngle(angle:Degree) -> (CoreAstrology.AspectRelation) {
        var closestAspectRelation:CoreAstrology.AspectRelationType = .opposition
        var degreeDiff:Degree = 360
        
        for aspect in CoreAstrology.AspectRelationType.allCases {
            let thisDegreeDiff:Degree = abs(aspect.degree - angle)
            if degreeDiff > thisDegreeDiff {
                closestAspectRelation = aspect
                degreeDiff = thisDegreeDiff
            }
        }
        
        let aspectRelation = CoreAstrology.AspectRelation(degrees: degreeDiff, forceWith: closestAspectRelation)
        return aspectRelation
    }
    
    public static func closestAspectRelation(for angle:Degree) -> CoreAstrology.AspectRelation {
        return closestAspectRelationForAngle(angle: angle)
    }
}

public struct AstroAspectTimeReport {
    
    /// Date and Time the Aspect is to occur
    public var date:Date
    
    /// The Aspect itself
    public var aspect:CoreAstrology.Aspect
    
    /// Angle Distance
    public var distance:Degree
    
    /// Convenience
    public var primaryBody:CoreAstrology.AspectBody { return aspect.primaryBody }
    public var secondaryBody:CoreAstrology.AspectBody { return aspect.secondaryBody }
    public var relation:CoreAstrology.AspectRelation { return aspect.relation }
    
    /// Calculations for Primary Body Distance
    public var primaryBodyDistance:Meter { return 0 }
    public var primaryBodyAngleRemaining:Degree { return 0 }
    
    /// Calculations for Secondary Body Distance
    public var secondBodyDistance:Meter { return 0 }
    public var secondBodyAngleRemaining:Degree { return 0 }
    
    /// Calculations for remainin
    public var timeOffset:TimeInterval { return date.timeIntervalSince(Date()) }
    
    /// Is this aspect within Orb Range
    public var withinRange:Bool { return relation.type.orb > abs(distance) }
}

extension CoreAstrology.AspectBody.NodeType {
//
//    public func celestialLongitude(_ date:Date? = nil) -> Degree? {
//        if let date = date {
//            switch self {
//            case .sun: return Planet.earthAA(date).position().celestialLongitude
//            case .mercury: return Planet.mercuryAA(date).position().celestialLongitude
//            case .venus: return Planet.venusAA(date).position().celestialLongitude
//            case .mars: return Planet.marsAA(date).position().celestialLongitude
//            case .jupiter: return Planet.jupiterAA(date).position().celestialLongitude
//            case .saturn: return Planet.saturnAA(date).position().celestialLongitude
//            case .uranus: return Planet.uranusAA(date).position().celestialLongitude
//            case .neptune: return Planet.neptuneAA(date).position().celestialLongitude
//            case .pluto: return Planet.plutoAA(date).position().celestialLongitude
//            default: return nil
//            }
//        }
//        switch self {
//        case .sun: return Planet.earthAA.position().celestialLongitude
//        case .mercury: return Planet.mercuryAA.position().celestialLongitude
//        case .venus: return Planet.venusAA.position().celestialLongitude
//        case .mars: return Planet.marsAA.position().celestialLongitude
//        case .jupiter: return Planet.jupiterAA.position().celestialLongitude
//        case .saturn: return Planet.saturnAA.position().celestialLongitude
//        case .uranus: return Planet.uranusAA.position().celestialLongitude
//        case .neptune: return Planet.neptuneAA.position().celestialLongitude
//        case .pluto: return Planet.plutoAA.position().celestialLongitude
//        default: return nil
//        }
//    }
    
    public func toAstronomy() -> CoreAstronomy.PlanetsAvailable? {
        switch self {
        case .sun: return .earth
        case .mercury: return .mercury
        case .venus: return .venus
        case .mars: return .mars
        case .jupiter: return .jupiter
        case .saturn: return .saturn
        case .uranus: return .uranus
        case .neptune: return .neptune
        case .pluto: return .pluto
        default: return nil
        }
    }
//    
//    public func orbitPeriodInSeconds() -> TimeInterval {
//        return Planet.planet(self.toAstronomy()!).orbitPeriodInSeconds
//    }
//    
//    public func heliocentricPosition() -> Degree {
//        return Planet.planet(self.toAstronomy()!).heliocentricPosition!
//    }
}

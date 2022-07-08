//
//  Astronomy.swift
//  HelmKit
//
//  Created by Jordan Trana on 7/23/18.
//  Copyright © 2018 Jordan Trana. All rights reserved.
//


import SwiftAA
import ObjCAA

open class CoreAstronomy {
    
    public enum PlanetsAvailable {
        case mercury
        case venus
        case earth
        case mars
        case jupiter
        case saturn
        case uranus
        case neptune
        case pluto
    }
    
//    public static func orbitalProgression(_ planet:PlanetsAvailable, on date:Date = Date()) -> Degree? {
//        return Planet.heliocentricPositions(for: planet, on: date).celestialLongitude
//    }
    
    public static func moonPhaseAngle(on date:Date = Date()) -> Degree {
        let julianDay = JulianDay(date)
        return Moon(julianDay: julianDay).phaseAngle()
    }
}

extension SwiftAA.Planet {
    public func position() -> (EclipticCoordinates) {
        return self.heliocentricEclipticCoordinates
    }
}

extension SwiftAA.Earth {
    public func position() -> (EclipticCoordinates) {
        return self.heliocentricEclipticCoordinates
    }
}

//extension SwiftAA.Pluto {
//    public func position() -> (EclipticCoordinates) {
//        return EclipticCoordinates(lambda: Degree(self.allObjectDetails.HeliocentricEclipticLongitude),
//                                   beta: Degree(self.allObjectDetails.HeliocentricEclipticLatitude))
//    }
//}

extension SwiftAA.PlanetaryBase {
    public func position() -> (EclipticCoordinates) {
        let longitude = KPCAAEclipticalElement_EclipticLongitude(self.julianDay.value, self.planet, self.highPrecision)
        let latitude = KPCAAEclipticalElement_EclipticLatitude(self.julianDay.value, self.planet, self.highPrecision)
        return EclipticCoordinates(lambda: Degree(longitude), beta: Degree(latitude))
    }
}
//
//public struct Planet: Equatable {
//
//    public let type: CoreAstronomy.PlanetsAvailable?
//
//    public static func ==(lhs: Planet, rhs: Planet) -> Bool {
//        return lhs.name == rhs.name &&
//            lhs.orbitalRadius == rhs.orbitalRadius &&
//            lhs.displayOrbitalRadius == rhs.displayOrbitalRadius &&
//            lhs.radius == rhs.radius &&
//            lhs.rotationDuration == rhs.rotationDuration &&
//            lhs.axialTilt == rhs.axialTilt &&
//            lhs.orbitPeriod == rhs.orbitPeriod
//    }
//
//    public let name: String
//
//    // Distance from the sun in millions of km
//    // Source: http://www.enchantedlearning.com/subjects/astronomy/planets/
//    public var orbitalRadius: Float
//    public var displayOrbitalRadius: Float {
//        get {
//            return orbitalRadius / 100
//        }
//    }
//
//    // In KM: eg. Earth 6371.0
//    // Source: https://en.wikipedia.org/wiki/List_of_Solar_System_objects_by_size
//    public let radius: Float
//
//    // In HOURS 🕥: eg. Earth 23.93, Mercury 1407.6
//    // Source: https://en.m.wikipedia.org/wiki/Axial_tilt#Solar_System_bodies
//    public let rotationDuration: Double
//
//    // Tilt on the poles in degrees: eg. Earth 23.44
//    // Source: https://en.m.wikipedia.org/wiki/Axial_tilt#Solar_System_bodies
//    public let axialTilt: Float
//
//    // Duration to circle the sun in earth YEARS 📅
//    // Source: https://en.wikipedia.org/wiki/Orbital_period#Examples_of_sidereal_and_synodic_periods
//    public let orbitPeriod: Double
//    public var orbitPeriodInSeconds: TimeInterval {
//        return orbitPeriod * 31557600
//    }
//
//    public var heliocentricPosition: Degree? {
//        guard let planet = self.type else { return nil }
//        switch planet {
//        case .mercury: return Planet.mercuryAA.heliocentricEclipticCoordinates.celestialLongitude
//        case .venus: return Planet.venusAA.heliocentricEclipticCoordinates.celestialLongitude
//        case .earth: return Planet.earthAA.heliocentricEclipticCoordinates.celestialLongitude
//        case .mars: return Planet.marsAA.heliocentricEclipticCoordinates.celestialLongitude
//        case .jupiter: return Planet.jupiterAA.heliocentricEclipticCoordinates.celestialLongitude
//        case .saturn: return Planet.saturnAA.heliocentricEclipticCoordinates.celestialLongitude
//        case .uranus: return Planet.uranusAA.heliocentricEclipticCoordinates.celestialLongitude
//        case .neptune: return Planet.neptuneAA.heliocentricEclipticCoordinates.celestialLongitude
//        case .pluto: return Planet.plutoAA.position().celestialLongitude
//        }
//    }
//
//
//    public static var timeOffset:TimeInterval?
//    public static var customDate:Date?
//    public static var date:Date {
//        guard customDate != nil else { return timeOffset != nil ? Date().addingTimeInterval(timeOffset!) : Date() }
//        return timeOffset != nil ? customDate!.addingTimeInterval(timeOffset!) : customDate!
//    }
//
//    public static var julianDay:JulianDay {
//        return JulianDay(date)
//    }
//
//    public static var mercuryAA:Mercury { return mercuryAA(date) }
//    public static var venusAA:Venus { return venusAA(date) }
//    public static var earthAA:Earth { return earthAA(date) }
//    public static var marsAA:Mars { return marsAA(date) }
//    public static var jupiterAA:Jupiter { return jupiterAA(date) }
//    public static var saturnAA:Saturn { return saturnAA(date) }
//    public static var uranusAA:Uranus { return uranusAA(date) }
//    public static var neptuneAA:Neptune { return neptuneAA(date) }
//    public static var plutoAA:Pluto { return plutoAA(date) }
//    public static var moonAA:Moon { return moonAA(date) }
//
//    public static func mercuryAA(_ date: Date) -> Mercury { return Mercury(julianDay: JulianDay(date)) }
//    public static func venusAA(_ date: Date) -> Venus { return Venus(julianDay: JulianDay(date)) }
//    public static func earthAA(_ date: Date) -> Earth { return Earth(julianDay: JulianDay(date)) }
//    public static func marsAA(_ date: Date) -> Mars { return Mars(julianDay: JulianDay(date)) }
//    public static func jupiterAA(_ date: Date) -> Jupiter { return Jupiter(julianDay: JulianDay(date)) }
//    public static func saturnAA(_ date: Date) -> Saturn { return Saturn(julianDay: JulianDay(date)) }
//    public static func uranusAA(_ date: Date) -> Uranus { return Uranus(julianDay: JulianDay(date)) }
//    public static func neptuneAA(_ date: Date) -> Neptune { return Neptune(julianDay: JulianDay(date)) }
//    public static func plutoAA(_ date: Date) -> Pluto { return Pluto(julianDay: JulianDay(date)) }
//    public static func moonAA(_ date: Date) -> Moon { return Moon(julianDay: JulianDay(date)) }
//
//    public static let sun = Planet(type: nil, name: "Sun", orbitalRadius: 0, radius: 695700, rotationDuration: 1000, axialTilt: 1, orbitPeriod: 1)
//    public static let mercury = Planet(type: .mercury, name: mercuryAA.name, orbitalRadius: 57.9, radius: 2439.7, rotationDuration: 1407.6, axialTilt: 0.03, orbitPeriod: 0.24084204)
//    public static let venus = Planet(type: .venus, name: venusAA.name, orbitalRadius: 108.2, radius: 6051.8, rotationDuration: 5832.6, axialTilt: 2.64, orbitPeriod: 0.61517237)
//    public static let earth = Planet(type: .earth, name: earthAA.name, orbitalRadius: 149.598023, radius: 6051.8, rotationDuration: 1, axialTilt: 23.4392811, orbitPeriod: 1)
//    public static let mars = Planet(type: .mars, name: marsAA.name, orbitalRadius: 227.9, radius: 6371, rotationDuration: 24.62, axialTilt: 25.19, orbitPeriod: 1.8808524)
//    public static let jupiter = Planet(type: .jupiter, name: jupiterAA.name, orbitalRadius: 778.3, radius: 69911, rotationDuration: 9.93, axialTilt: 3.13, orbitPeriod: 11.86631421)
//    public static let saturn = Planet(type: .saturn, name: saturnAA.name, orbitalRadius: 1427, radius: 58232, rotationDuration: 10.66, axialTilt: 26.73, orbitPeriod: 29.47305083)
//    public static let uranus = Planet(type: .uranus, name: uranusAA.name, orbitalRadius: 2871, radius: 25362, rotationDuration: 17.24, axialTilt: 82.23, orbitPeriod: 84.05122725)
//    public static let neptune = Planet(type: .neptune, name: neptuneAA.name, orbitalRadius: 4497, radius: 24622, rotationDuration: 16.11, axialTilt: 28.32, orbitPeriod: 164.88839750)
//    public static let pluto = Planet(type: .pluto, name: plutoAA.name, orbitalRadius: 5907, radius: 1188, rotationDuration: 153.288, axialTilt: 122.53, orbitPeriod: 248.12989786)
//
//    public static let allPlanets = [sun, mercury, venus, earth, mars, jupiter, saturn, uranus, neptune, pluto]
//
//    public static func planet(_ planet:CoreAstronomy.PlanetsAvailable) -> Planet {
//        return allPlanets.first(where: { $0.type == planet })!
//    }
//
//    public static func heliocentricPositions(for planet:CoreAstronomy.PlanetsAvailable, on date:Date) -> EclipticCoordinates {
//        let julianDay = JulianDay(date)
//        switch planet {
//        case .mercury: return Mercury(julianDay: julianDay).heliocentricEclipticCoordinates
//        case .venus: return Venus(julianDay: julianDay).heliocentricEclipticCoordinates
//        case .earth: return Earth(julianDay: julianDay).heliocentricEclipticCoordinates
//        case .mars: return Mars(julianDay: julianDay).heliocentricEclipticCoordinates
//        case .jupiter: return Jupiter(julianDay: julianDay).heliocentricEclipticCoordinates
//        case .saturn: return Saturn(julianDay: julianDay).heliocentricEclipticCoordinates
//        case .uranus: return Uranus(julianDay: julianDay).heliocentricEclipticCoordinates
//        case .neptune: return Neptune(julianDay: julianDay).heliocentricEclipticCoordinates
//        case .pluto: return Pluto(julianDay: julianDay).position()
//        }
//    }
//
//    public static func heliocentricPositions2(for planet:CoreAstronomy.PlanetsAvailable, on date:Date) -> EclipticCoordinates {
//        let julianDay = JulianDay(date)
//        switch planet {
//        case .mercury: return Mercury(julianDay: julianDay).heliocentricEclipticCoordinates
//        case .venus: return Venus(julianDay: julianDay).heliocentricEclipticCoordinates
//        case .earth: return Earth(julianDay: julianDay).heliocentricEclipticCoordinates
//        case .mars: return Mars(julianDay: julianDay).heliocentricEclipticCoordinates
//        case .jupiter: return Jupiter(julianDay: julianDay).heliocentricEclipticCoordinates
//        case .saturn: return Saturn(julianDay: julianDay).heliocentricEclipticCoordinates
//        case .uranus: return Uranus(julianDay: julianDay).heliocentricEclipticCoordinates
//        case .neptune: return Neptune(julianDay: julianDay).heliocentricEclipticCoordinates
//        case .pluto: return Pluto(julianDay: julianDay).position()
//        }
//    }
//}

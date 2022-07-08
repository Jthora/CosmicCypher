//
//  Earth+Extension.swift
//  EarthquakeFinderCreateML
//
//  Created by Jordan Trana on 9/25/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import Foundation
import SwiftAA
import ObjCAA
import Darwin

extension Earth {
    
    public enum House:Double {
        case first = 3  // ASC
        case second = 4
        case third = 5
        case forth = 6 // IC or
        case fifth = 7
        case sixth = 8
        case seventh = 9 // DSC
        case eighth = 10
        case nineth = 11
        case tenth = 0  // MC or Midheaven
        case eleventh = 1
        case twelveth = 2
        
        public var technicalDegree:Degree {
            switch self {
            case .first, .seventh: return 90
            case .second, .eighth: return 120
            case .third, .nineth: return 150
            case .tenth, .forth: return 0
            case .eleventh, .fifth: return 30
            case .twelveth, .sixth: return 60
            }
        }
        
        public var factor:Double {
            switch self {
            case .eleventh, .fifth: return 1.5
            case .twelveth, .sixth: return 3
            case .second, .eighth: return 3
            case .third, .nineth: return 1.5
            default: return 1
            }
        }
    }
    
    
    public func getLocalSiderealTime(coords:GeographicCoordinates) -> Degree {
        return self.julianDay.meanLocalSiderealTime(longitude: coords.longitude).inDegrees
    }

    public func getMidHeaven(coords:GeographicCoordinates) -> Degree {
        var LST = getLocalSiderealTime(coords: coords)
        if LST < 0 {
            LST += 360
        }
        let ecliptic = self.obliquityOfEcliptic(mean: true).inRadians.value
        let MC = atan(tan(LST.inRadians.value) / cos(ecliptic))
        var MCdeg = Radian(MC).inDegrees
        if MCdeg < 0 {
            MCdeg += 180
        }
        if LST > 180 {
            MCdeg += 180
        }
        MCdeg = Degree(MCdeg.value.truncatingRemainder(dividingBy: 360))

        return MCdeg
    }
    
    public func getASC(coords:GeographicCoordinates) -> Degree {
        
        //let precession = self.position().precessedCoordinates(to: .epochOfTheDate(self.julianDay))
        //let position = self.position()
        //let equatorialPosition = self.position().makeEquatorialCoordinates()
        //let equatorialPrecession = equatorialPosition.precessedCoordinates(to: .meanEquinoxOfTheDate(self.julianDay))
        //let equatorialPositionRA = equatorialPosition.rightAscension.inDegrees
        //let galacticCoords = self.position().makeEquatorialCoordinates().makeGalacticCoordinates()
        //let horizontal = self.position().makeEquatorialCoordinates().makeHorizontalCoordinates(for: coords, at: self.julianDay)
        
        let latitude = coords.latitude.inRadians.value
        let ecliptic = self.obliquityOfEcliptic(mean: true).inRadians.value // obliquityOfEcliptic 'Inclination'
        var LST = getLocalSiderealTime(coords: coords)
        if LST < 0 {
            LST += 360
        }
        
        let radLST = LST.inRadians.value
        
        
        let y = -cos(radLST)
        let x = sin(radLST)*cos(ecliptic)+tan(latitude)*sin(ecliptic)
        
        let radASC = atan(y/x)
        var degASC = Radian(radASC).inDegrees
        
        if x < 0 {
            degASC += 180
        } else {
            degASC += 360
        }
        
        if degASC < 180 {
            degASC += 180
        } else {
            degASC -= 180
        }
        
        return degASC
    }
    
    
    public func acot(_ x : Double) -> Double {
        if x > 1.0 {
            return atan(1.0/x)
        } else if x < -1.0 {
            return .pi/2 + atan(1.0/x)
        } else {
            return .pi/2 - atan(x)
        }
    }
    
    public func getCelestialLongitudeOfHouseCusp(house: House, coords:GeographicCoordinates) -> Degree {
        
        if house == .first { return getASC(coords: coords) }
        else if house == .seventh { return Degree((getASC(coords: coords).value + 180).truncatingRemainder(dividingBy: 360)) }
        else if house == .tenth { return getMidHeaven(coords: coords) }
        else if house == .forth { return Degree((getMidHeaven(coords: coords).value + 180).truncatingRemainder(dividingBy: 360)) }
        else {
            
            let ecliptic = self.obliquityOfEcliptic(mean: true).inRadians.value
            let latitude = coords.latitude.inRadians.value
            
            // Local Sidereal Time (in Degrees)
            let RAMC = getLocalSiderealTime(coords: coords)//getRightAscensionOfMidheaven(coords: coords)
            
            // Factor
            let F = house.factor
            
            // House
            let H = house.technicalDegree
            
            // Declination
            let D = asin(sin(ecliptic)*sin(H.inRadians.value))
            
            // Right Asc by House
            var RA = RAMC + H
            
            let threshold = Degree(0.1)
            
            while (abs(RA) - abs(Radian(D).inDegrees) > threshold) {
                if house == .twelveth || house == .eleventh || house == .sixth || house == .fifth {
                    RA = RAMC + Radian(acos(-sin(RA.inRadians.value) * tan(ecliptic) * tan(latitude)) / F).inDegrees
                } else {
                    RA = RAMC + 180 - Radian(acos(-sin(RA.inRadians.value) * tan(ecliptic) * tan(latitude)) / F).inDegrees
                }
            }
            
            let celestialLongitude = atan(sin(RA.inRadians.value) / cos(ecliptic) * cos(RA.inRadians.value))
            let result = Radian(celestialLongitude).inDegrees
            
            if house == .nineth || house == .eighth || house == .sixth || house == .fifth {
                return Degree((result.value + 180).truncatingRemainder(dividingBy: 360))
            } else {
                return result
            }
        }
        
        
        
    }
    
    
    public func isNightTime(coords:GeographicCoordinates) -> Bool? {
        return nil
//        let twilights = self.twilights(forSunAltitude: TwilightSunAltitude.astronomical.rawValue, coordinates: coords)
//        guard let rise = twilights.rise,
//            let set = twilights.set else {
//                print("isNightTime ERROR: \(twilights.error)")
//                return false
//        }
//        let isNight = self.julianDay.isBefore(rise) || self.julianDay.isAfter(set)
//        return isNight
    }

    // Day Births: Ascendant + Moon – Sun
    // Night Births: Ascendant + Sun – Moon
    
    // X Cross Circle
    public func getPartOfFortune(coords:GeographicCoordinates) -> Degree? {
        
        guard let isNightTime:Bool = isNightTime(coords:coords) else {return nil}
        
        let ASC = getASC(coords: coords)
        let SUN = Sun(julianDay: self.julianDay).equatorialCoordinates.alpha.inDegrees
        let MOON = Moon(julianDay: self.julianDay).equatorialCoordinates.alpha.inDegrees
        
        if isNightTime {
            return ASC + MOON - SUN
        } else {
            return ASC + SUN - MOON
        }
    }
    
    // Day chart: Ascendant - Moon + Sun
    // Night chart: Ascendant + Moon - Sun
    
    // The Power of the Spiral
    public func getPartOfSpirit(coords:GeographicCoordinates) -> Degree? {
        
        guard let isNightTime:Bool = isNightTime(coords:coords) else {return nil}
        
        let ASC = getASC(coords: coords)
        let SUN = Sun(julianDay: self.julianDay).equatorialCoordinates.alpha.inDegrees
        let MOON = Moon(julianDay: self.julianDay).equatorialCoordinates.alpha.inDegrees
        
        if isNightTime {
            return ASC - MOON + SUN
        } else {
            return ASC + MOON - SUN
        }
    }
    
    // Day chart: ASC + Venus - Spirit
    // Night chart: ASC + Spirit - Venus
    
    // The Power of the Spiral
    public func getPartOfEros(coords:GeographicCoordinates) -> Degree? {
        
        guard let isNightTime:Bool = isNightTime(coords:coords) else {return nil}
        
        let ASC = getASC(coords: coords)
        let VENUS = Venus(julianDay: self.julianDay).equatorialCoordinates.alpha.inDegrees
        guard let SPIRIT:Degree = self.getPartOfSpirit(coords: coords) else { return nil }
        
        if isNightTime {
            return ASC + SPIRIT - VENUS
        } else {
            return ASC + VENUS - SPIRIT
        }
    }

    
    
}

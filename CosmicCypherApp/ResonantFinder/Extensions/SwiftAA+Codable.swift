//
//  SwiftAA+Codable.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 6/6/22.
//

import Foundation
import SwiftAA


extension GeographicCoordinates: Codable {
    enum CodingKeys: CodingKey {
        case longitude
        case latitude
        case altitude
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(longitude, forKey: .longitude)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(altitude, forKey: .altitude)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let longitude = try container.decode(Degree.self, forKey: .longitude)
        let latitude = try container.decode(Degree.self, forKey: .latitude)
        let altitude = try container.decode(Meter.self, forKey: .altitude)
        self = GeographicCoordinates(positivelyWestwardLongitude: longitude,
                                     latitude: latitude,
                                     altitude: altitude)
    }
}

extension EquatorialCoordinates: Codable {
    enum CodingKeys: CodingKey {
        case rightAscension
        case declination
        case epoch
        case equinox
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(rightAscension.value, forKey: .rightAscension)
        try container.encode(declination.value, forKey: .declination)
        try container.encode(epoch.codingValue, forKey: .epoch)
        try container.encode(equinox.codingValue, forKey: .equinox)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rightAscension = try container.decode(Double.self, forKey: .rightAscension)
        let declination = try container.decode(Double.self, forKey: .declination)
        let epoch = try container.decode(Double.self, forKey: .epoch)
        let equinox = try container.decode(Double.self, forKey: .equinox)
        
        self = EquatorialCoordinates(rightAscension: Hour(rightAscension),
                                     declination: Degree(declination),
                                     epoch: Epoch(julianDay: JulianDay(epoch)),
                                     equinox: Equinox(julianDay: JulianDay(equinox)))
    }
}

extension Degree: Codable {
    enum CodingKeys: CodingKey {
        case value
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self = Degree(try container.decode(Double.self, forKey: .value))
    }
}

extension Meter: Codable {
    enum CodingKeys: CodingKey {
        case value
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self = Meter(try container.decode(Double.self, forKey: .value))
    }
}

extension AstronomicalUnit: Codable {
    enum CodingKeys: CodingKey {
        case value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self = AstronomicalUnit(try container.decode(Double.self, forKey: .value))
    }
}

extension Hour: Codable {
    enum CodingKeys: CodingKey {
        case value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self = Hour(try container.decode(Double.self, forKey: .value))
    }
}

extension JulianDay: Codable {
    enum CodingKeys: CodingKey {
        case value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self = JulianDay(try container.decode(Double.self, forKey: .value))
    }
    
    public var codingValue: Double {
        return value
    }
    
}

extension Epoch: Codable {
    enum CodingKeys: CodingKey {
        case julianDay
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .epochOfTheDate(let julianDay): try container.encode(julianDay.codingValue, forKey: .julianDay)
        case .J2000: try container.encode(StandardEpoch_J2000_0.codingValue, forKey: .julianDay)
        case .B1950: try container.encode(StandardEpoch_B1950_0.codingValue, forKey: .julianDay)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let codingValue = try container.decode(Double.self, forKey: .julianDay)
        let julianDay = JulianDay(codingValue)
        self = Epoch(julianDay: julianDay)
    }
    
    public init(julianDay:JulianDay) {
        if julianDay == StandardEpoch_J2000_0 {
            self = .J2000
        } else if julianDay == StandardEpoch_B1950_0 {
            self = .B1950
        } else {
            self = .epochOfTheDate(julianDay)
        }
    }
    
    var codingValue: Double {
        switch self {
        case .epochOfTheDate(let julianDay):
            return julianDay.codingValue
        case .J2000:
            return StandardEpoch_J2000_0.codingValue
        case .B1950:
            return StandardEpoch_B1950_0.codingValue
        }
    }
}

extension Equinox: Codable {
    enum CodingKeys: CodingKey {
        case julianDay
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .meanEquinoxOfTheDate(let julianDay): try container.encode(julianDay.codingValue, forKey: .julianDay)
        case .standardJ2000: try container.encode(StandardEpoch_J2000_0.codingValue, forKey: .julianDay)
        case .standardB1950: try container.encode(StandardEpoch_B1950_0.codingValue, forKey: .julianDay)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let codingValue = try container.decode(Double.self, forKey: .julianDay)
        let julianDay = JulianDay(codingValue)
        self = Equinox(julianDay: julianDay)
    }
    
    public init(julianDay:JulianDay) {
        if julianDay == StandardEpoch_J2000_0 {
            self = .standardJ2000
        } else if julianDay == StandardEpoch_B1950_0 {
            self = .standardB1950
        } else {
            self = .meanEquinoxOfTheDate(julianDay)
        }
    }
    
    var codingValue: Double {
        switch self {
        case .meanEquinoxOfTheDate(let julianDay):
            return julianDay.codingValue
        case .standardJ2000:
            return StandardEpoch_J2000_0.codingValue
        case .standardB1950:
            return StandardEpoch_B1950_0.codingValue
        }
    }
}

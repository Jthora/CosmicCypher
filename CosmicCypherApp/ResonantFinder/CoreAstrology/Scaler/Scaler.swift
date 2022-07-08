//
//  Scaler.swift
//  HelmKit
//
//  Created by Jordan Trana on 11/1/18.
//  Copyright © 2018 Jordan Trana. All rights reserved.
//

import Foundation

struct Scaler: Codable {
    
    enum ColorMode: Int, CaseIterable {
        case ticks
        case color
        case both
        
        var name:String {
            switch self {
            case .ticks: return "Ticks"
            case .color: return "Color"
            case .both: return "Both"
            }
        }
    }
    
    enum PlanetFocus: Int, CaseIterable {
        case moon
        case mercury
        case venus
        case earth
        case mars
        case jupiter
        case saturn
        case uranus
        case neptune
        case pluto
        
        var name:String {
            switch self {
            case .moon: return "Moon"
            case .mercury: return "Mercury"
            case .venus: return "Venus"
            case .earth: return "Earth"
            case .mars: return "Mars"
            case .jupiter: return "Jupiter"
            case .saturn: return "Saturn"
            case .uranus: return "Uranus"
            case .neptune: return "Neptune"
            case .pluto: return "Pluto"
            }
        }
        
        var symbol:String {
            switch self {
            case .moon: return "🌙"
            case .mercury: return "☿"
            case .venus: return "♀"
            case .earth: return "🌎"
            case .mars: return "♂"
            case .jupiter: return "J"
            case .saturn: return "S"
            case .uranus: return "U"
            case .neptune: return "N"
            case .pluto: return "P"
            }
        }
        
        var seconds:TimeInterval {
            switch self {
            case .moon: return 2551392 // (86400 * 29.53)
            case .mercury: return 7600522 // (87.969 * 86400)
            case .venus: return 19414166 // (224.701 * 86400)
            case .earth: return 31557600
            case .mars: return 59354294 // (686.971 * 86400)
            case .jupiter: return 374335776 // (4332.59 * 86400)
            case .saturn: return 929596608 // (10759.22  * 86400)
            case .uranus: return 2651486400 // (30688.5 * 86400)
            case .neptune: return 5199724800 // (60182 * 86400)
            case .pluto: return 7824384000 // (90560 * 86400)
            }
        }
    }
    
    enum TickScaleUnit: Int, CaseIterable {
        case degrees
        case arcseconds
        case base60
        case base2
        case base3
        case base4
        case base6
        case base8
        case base10
        case base12
        case base16
        case base24
        case base32
        case base48
        case base64
        case base96
        case base128
        case base256
        case base512
        case base1024
        
        var ticks:Int {
            switch self {
            case .degrees: return 360
            case .arcseconds: return 1296000
            case .base60: return 60
            case .base2: return 2
            case .base3: return 3
            case .base4: return 4
            case .base6: return 6
            case .base8: return 8
            case .base10: return 10
            case .base12: return 12
            case .base16: return 16
            case .base24: return 24
            case .base32: return 32
            case .base48: return 48
            case .base64: return 64
            case .base96: return 96
            case .base128: return 128
            case .base256: return 256
            case .base512: return 512
            case .base1024: return 1024
            }
        }
        
        var name:String {
            switch self {
            case .degrees: return "deg"
            case .arcseconds: return "arcsec"
            case .base60: return "b 60"
            case .base2: return "b 2"
            case .base3: return "b 3"
            case .base4: return "b 4"
            case .base6: return "b 6"
            case .base8: return "b 8"
            case .base10: return "b 10"
            case .base12: return "b 12"
            case .base16: return "b 16"
            case .base24: return "b 24"
            case .base32: return "b 32"
            case .base48: return "b 48"
            case .base64: return "b 64"
            case .base96: return "b 96"
            case .base128: return "b128"
            case .base256: return "b256"
            case .base512: return "b512"
            case .base1024: return "b1024"
            }
        }
    }
    
    enum TimeScaleUnit: Int, CaseIterable {
        case custom
        case pt
        case milisec
        case sec
        case min
        case hr
        case day
        case yuga
        case precession
        
        var name:String {
            switch self {
            case .custom: return "Custom"
            case .pt: return "PlanckTime"
            case .milisec: return "Milisecond"
            case .sec: return "Second"
            case .min: return "Minute"
            case .hr: return "Hour"
            case .day: return "Day"
            case .yuga: return "YugaCycle"
            case .precession: return "Precession"
            }
        }
        
        var seconds:TimeInterval {
            switch self {
            case .custom: return 1
            case .pt: return TimeInterval(5.391 * pow(10.0, -44.0))
            case .milisec: return 0.001
            case .sec: return 1
            case .min: return 60
            case .hr: return 3600
            case .day: return 86400
            case .yuga: return 757382400000 // (31557600 * 24000)
            case .precession: return 813302467200 // (31557600 * 25772)
            }
        }
    }
    
    static var defaultScalers: [Scaler] = {
        return [Scaler(name: "Top", colorMode: .ticks, planetFocus: .earth, timeUnit: .pt, tickUnit: .base48, power: 2.0, scale: 145),
                Scaler(name: "Middle", colorMode: .ticks, planetFocus: .mercury, timeUnit: .sec, tickUnit: .degrees, power: 10.0, scale: 1),
                Scaler(name: "Bottom", colorMode: .ticks, planetFocus: .moon, timeUnit: .day, tickUnit: .degrees, power: 7.0, scale: 1)]
    }()
    
    static var multipliers : [String:NSNumber] = { return TranscendentalNumber.dictionary + PrimeNumber.dictionary }()
    
    var colorMode:ColorMode
    var planetFocus:PlanetFocus
    var timeUnit:TimeScaleUnit
    var tickUnit:TickScaleUnit
    var power:Double
    var scale:Int
    var name:String
    
    var timeWindow:TimeInterval {
        return timeUnit.seconds * pow(power, Double(scale))
    }
    
    var tickCount:Int {
        return tickUnit.ticks
    }
    
    enum CodingKeys: String, CodingKey {
        case colorMode
        case planetFocus
        case timeUnit
        case tickUnit
        case name
        case power
        case scale
    }
    
    init (name:String, colorMode:ColorMode = .ticks, planetFocus:PlanetFocus = .earth, timeUnit:TimeScaleUnit = .pt, tickUnit:TickScaleUnit = .degrees, power:Double = 2, scale:Int = 150) {
        self.colorMode = colorMode
        self.planetFocus = planetFocus
        self.timeUnit = timeUnit
        self.tickUnit = tickUnit
        self.power = power
        self.scale = scale
        self.name = name
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let colorModeInt = try values.decode(Int.self, forKey: .colorMode)
        if let colorMode = ColorMode(rawValue: colorModeInt) {
            self.colorMode = colorMode
        } else {
            throw NSError(domain: "PlanetFocus not found", code: -1, userInfo: nil)
        }
        
        let planetFocusInt = try values.decode(Int.self, forKey: .planetFocus)
        if let planetFocus = PlanetFocus(rawValue: planetFocusInt) {
            self.planetFocus = planetFocus
        } else {
            throw NSError(domain: "PlanetFocus not found", code: -1, userInfo: nil)
        }
        
        let timeUnitInt = try values.decode(Int.self, forKey: .timeUnit)
        if let timeUnit = TimeScaleUnit(rawValue: timeUnitInt) {
            self.timeUnit = timeUnit
        } else {
            throw NSError(domain: "TimeScaleUnit not found", code: -1, userInfo: nil)
        }
        
        let tickUnitInt = try values.decode(Int.self, forKey: .tickUnit)
        if let tickUnit = TickScaleUnit(rawValue: tickUnitInt) {
            self.tickUnit = tickUnit
        } else {
            throw NSError(domain: "TickScaleUnit not found", code: -1, userInfo: nil)
        }
        
        name = try values.decode(String.self, forKey: .name)
        power = try values.decode(Double.self, forKey: .power)
        scale = try values.decode(Int.self, forKey: .scale)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(colorMode.rawValue, forKey: .colorMode)
        try container.encode(planetFocus.rawValue, forKey: .planetFocus)
        try container.encode(timeUnit.rawValue, forKey: .timeUnit)
        try container.encode(tickUnit.rawValue, forKey: .tickUnit)
        try container.encode(name, forKey: .name)
        try container.encode(power, forKey: .power)
        try container.encode(scale, forKey: .scale)
    }
}

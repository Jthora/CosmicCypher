//
//  TimeStreamGenerator.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 6/6/22.
//

import Foundation
import SwiftAA

extension TimeStream {
    
    static func generate(_ option: Generator.Option) -> TimeStream {
        return option.generate()
    }
    
    public final class Generator {
        
        static func generate(_ option: Option) -> TimeStream {
            return option.generate()
        }
        
        // Default Sets
        
        public enum Option {
            
            public enum DataMetricOption {
                case harmonics
                case retrogrades
                case gravimetrics
                case distance
                
                init(_ dataMetric:TimeStream.DataMetric) {
                    switch dataMetric {
                    case .harmonics:
                        self = .harmonics
                    case .retrogrades:
                        self = .retrogrades
                    case .gravimetrics:
                        self = .gravimetrics
                    case .distance:
                        self = .distance
                    }
                }
                
                var dataMetric:TimeStream.DataMetric {
                    switch self {
                    case .harmonics:
                        return .harmonics
                    case .retrogrades:
                        return .retrogrades
                    case .gravimetrics:
                        return .gravimetrics
                    case .distance:
                        return .distance
                    }
                }
            }
            
            case custom(_ startDate:Date,
                        _ endDate:Date,
                        _ geographicCoordinates:GeographicCoordinates = .zero,
                        _ title:String = "Custom",
                        _ dataMetricOption: DataMetricOption = .harmonics,
                        _ planets:[CoreAstrology.AspectBody.NodeType] = [.ascendant,.moon,.sun, .mercury, .venus])
            
            case yesterday(_ dataMetricOption: DataMetricOption? = nil)
            case today(_ dataMetricOption: DataMetricOption? = nil)
            case tomorrow(_ dataMetricOption: DataMetricOption? = nil)
            
            case earthCentric // Earth Centric (gravimetrics)
            case solarCentric // Solar Centric (gravimetrics)
            case interplanetaryWeb // Interplanetary Web (gravimetrics)
            
            case worldsCore // Core Worlds (harmonics)
            case worldsOuter // Outer Worlds (harmonics)
            case worldsAll // All Worlds (harmonics)
            
            case thisMonth(_ dataMetricOption: DataMetricOption? = nil) // This Lunar
            case thisYear(_ dataMetricOption: DataMetricOption? = nil) // This Solar
            case thisSolarCycle(_ dataMetricOption: DataMetricOption? = nil) // This Star Pulse
            
//            case thisLunarMonth // This Lunar
//            case thisSolarYear // This Solar
//            case thisStarPulse // This Star Pulse
            
            case thisJupiterSaturnPhase // (harmonics) This Jupiter Saturn Conjunction Phase (~20 earth years)
            case thisYugaCycle // (harmonics) This Yuga Cycle (Precession of the Equinox - Earth Axis Tilt Rotation ~26000 earth years)
            case thisUranusNeptunePhase // (harmonics) This Uranus Neptune Conjunction Phase (~168 earth years)
            
            case interPersonal // Interpersonal (harmonics)
            case intraPersonal // Intrapersonal (harmoncis)
            case personal // Personal (harmonics)
            
            
            static let defaultSet:[Option] = [.thisYear(.harmonics),.thisSolarCycle(.harmonics),.today(.harmonics),.tomorrow(.harmonics),.thisMonth(.harmonics)]
            
            
            func generate() -> TimeStream {
                
                switch self {
                case .custom(let startDate, let endDate, let geographicCoordinates, let title, _, _):
                    return TimeStream(title: title,
                                      startDate: startDate,
                                      endDate: endDate,
                                      coordinates: geographicCoordinates)
                case .yesterday:
                    return TimeStream(title: title,
                                                   startDate: Date.beginningOf(.yesterday)!,
                                                   endDate: Date.beginningOf(.today)!,
                                                   coordinates: .zero)
                case .today: return TimeStream(title: title,
                                               startDate: Date.beginningOf(.today)!,
                                               endDate: Date.beginningOf(.tomorrow)!,
                                               coordinates: .zero)
                case .tomorrow: return TimeStream(title: title,
                                                  startDate: Date.beginningOf(.tomorrow)!,
                                                  endDate: Date.beginningOf(.dayAfterToday(2))!,
                                                  coordinates: .zero)
                    
                case .earthCentric: return TimeStream(title: title,
                                                      startDate: Date.beginningOf(.thisYear)!,
                                                      endDate: Date.endOf(.thisYear)!,
                                                      coordinates: .zero)
                case .solarCentric: return TimeStream(title: title,
                                                      startDate: Date.beginningOf(.thisYear)!,
                                                      endDate: Date.endOf(.nextYear)!,
                                                      coordinates: .zero)
                case .interplanetaryWeb: return TimeStream(title: title,
                                                           startDate: Date.beginningOf(.thisYear)!,
                                                           endDate: Date.endOf(.nextYear)!,
                                                           coordinates: .zero)
                    
                case .worldsCore: return TimeStream(title: title,
                                                    startDate: Date.beginningOf(.thisYear)!,
                                                    endDate: Date.endOf(.nextYear)!,
                                                    coordinates: .zero)
                case .worldsOuter: return TimeStream(title: title,
                                                     startDate: Date.beginningOf(.thisYear)!, endDate: Date.endOf(.nextYear)!,
                                                     coordinates: .zero)
                case .worldsAll: return TimeStream(title: title,
                                                   startDate: Date.beginningOf(.thisYear)!,
                                                   endDate: Date.endOf(.nextYear)!,
                                                   coordinates: .zero)
                    
                case .thisMonth: return TimeStream(title: title,
                                                   startDate: Date.beginningOf(.thisMonth)!,
                                                   endDate: Date.beginningOf(.nextMonth)!,
                                                   coordinates: .zero)
                case .thisYear: return TimeStream(title: title,
                                                  startDate: Date.beginningOf(.thisYear)!,
                                                  endDate: Date.endOf(.nextYear)!,
                                                  coordinates: .zero)
                case .thisSolarCycle: return TimeStream(title: title,
                                                        startDate: Date.beginningOf(.year(2020))!,
                                                        endDate: Date.endOf(.year(2032))!,
                                                        coordinates: .zero)
                    
//                case .thisLunarMonth: return TimeStream(startDate: Date(), endDate: Date(), coordinates: .zero)
//                case .thisSolarYear: return TimeStream(startDate: Date.beginningOf(.thisYear)!, endDate: Date.endOf(.nextYear)!, coordinates: .zero)
//                case .thisStarPulse: return TimeStream(startDate: Date(), endDate: Date(), coordinates: .zero)
                    
                case .thisJupiterSaturnPhase: return TimeStream(startDate: Date(), endDate: Date(), coordinates: .zero)
                case .thisYugaCycle: return TimeStream(startDate: Date(), endDate: Date(), coordinates: .zero)
                case .thisUranusNeptunePhase: return TimeStream(startDate: Date(), endDate: Date(), coordinates: .zero)
                    
                case .interPersonal: return TimeStream(startDate: Date(), endDate: Date(), coordinates: .zero)
                case .intraPersonal: return TimeStream(startDate: Date(), endDate: Date(), coordinates: .zero)
                case .personal: return TimeStream(startDate: Date(), endDate: Date(), coordinates: .zero)
                }
            }
            
            var title:String {
                switch self {
                case .custom( _, _, _, let title, _, _): return title
                case .yesterday: return "Yesterday"
                case .today: return "Today"
                case .tomorrow: return "Tomorrow"
                case .earthCentric: return "Earth Centric"
                case .solarCentric: return "Solar Centric"
                case .interplanetaryWeb: return "Interplanetary Web"
                case .worldsCore: return "Inner Worlds"
                case .worldsOuter: return "Outer Worlds"
                case .worldsAll: return "All Worlds"
                case .thisMonth: return "This Month"
                case .thisYear: return "This Year"
                case .thisSolarCycle: return "This Solar Cycle"
                case .thisJupiterSaturnPhase: return "This Jupiter Saturn Phase"
                case .thisYugaCycle: return "This Yuga Cycle"
                case .thisUranusNeptunePhase: return "This Uranus Neptune Phase"
                case .interPersonal: return "Inter Personal"
                case .intraPersonal: return "Intra Personal"
                case .personal: return "Personal"
                }
            }
            
            var nodeTypes:[CoreAstrology.AspectBody.NodeType] {
                switch self {
                case .custom( _, _, _, _, _, let planets): return planets
                case .yesterday: return [.ascendant,.moon,.sun, .mercury, .venus]
                case .today: return [.ascendant,.moon,.sun, .mercury, .venus]
                case .tomorrow: return [.ascendant,.moon,.sun, .mercury, .venus]
                case .earthCentric: return [.sun,.moon]
                case .solarCentric: return [.mercury,.sun,.jupiter]
                case .interplanetaryWeb: return [.ascendant,.moon,.sun]
                case .worldsCore: return [.mercury, .venus, .sun, .mars]
                case .worldsOuter: return [.jupiter, .saturn, .uranus, .neptune]
                case .worldsAll: return DEFAULT_SELECTED_NODETYPES
                case .thisMonth: return [.moon,.sun]
                case .thisYear: return [.sun,.venus,.mercury]
                case .thisSolarCycle: return [.sun,.mars,.jupiter]
                case .thisJupiterSaturnPhase: return [.jupiter,.saturn]
                case .thisYugaCycle: return [.pluto]
                case .thisUranusNeptunePhase: return [.uranus,.neptune]
                case .interPersonal: return [.ascendant,.moon,.sun]
                case .intraPersonal: return [.ascendant,.moon,.sun]
                case .personal: return [.ascendant,.moon,.sun]
                }
            }
            
            var sampleCount:Int {
                return 100
//                switch self {
//                case .yesterday: return 24*60
//                case .today: return 24*60
//                case .tomorrow: return 24*60
//                case .earthCentric: return 365
//                case .solarCentric: return 365
//                case .interplanetaryWeb: return 365
//                case .worldsCore: return 365
//                case .worldsOuter: return 365
//                case .worldsAll: return 365
//                case .thisMonth: return 24*60
//                case .thisYear: return 365
//                case .thisSolarCycle: return 100
//                case .thisJupiterSaturnPhase: return 100
//                case .thisYugaCycle: return 360
//                case .thisUranusNeptunePhase: return 365
//                case .interPersonal: return 365
//                case .intraPersonal: return 365
//                case .personal: return 365
//                }
                
            }
            
        }
    }
}


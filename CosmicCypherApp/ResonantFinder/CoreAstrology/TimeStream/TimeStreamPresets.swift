//
//  TimeStreamPresets.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 7/2/22.
//

import Foundation
import UIKit

extension TimeStream {
    enum Preset: Int, CaseIterable {
        case astroHarmonicsToday
        case astroHarmonicsThisMonth
        case astroHarmonicsThisYear
        case astroHarmonicsThisSolarCycle
        case geoCentricGravimetrics
        case helioCentricGravimetrics
        case interPlanetaryGravimetrics
        
        
        var titleText:String {
            switch self {
            case .astroHarmonicsToday,
                    .astroHarmonicsThisYear,
                    .astroHarmonicsThisMonth,
                    .astroHarmonicsThisSolarCycle:
                return "Astro Harmonic Measurements"
            case .geoCentricGravimetrics:
                return "Geocentric Gravimetrics"
            case .helioCentricGravimetrics:
                return "Heliocentric Gravimetrics"
            case .interPlanetaryGravimetrics:
                return "Interplanetary Gravimetrics"
            }
        }
        
        var subTitleText:String {
            switch self {
            case .astroHarmonicsToday:
                return "Today"
            case .astroHarmonicsThisYear:
                return "This Year"
            case .astroHarmonicsThisMonth:
                return "This Month"
            case .astroHarmonicsThisSolarCycle:
                return "This Solar Cycle"
            case .geoCentricGravimetrics:
                return "This Year"
            case .helioCentricGravimetrics:
                return "This Year"
            case .interPlanetaryGravimetrics:
                return "This Year"
            }
        }
        
        // Is this preset option selectable?
        var enabled:Bool { return true }
        
        func timestream() -> TimeStream {
            switch self {
            case .astroHarmonicsToday:
                let timestream = TimeStream.generate(.today(.harmonics))
                return timestream
            case .astroHarmonicsThisMonth:
                let timestream = TimeStream.generate(.thisMonth(.harmonics))
                return timestream
            case .astroHarmonicsThisYear:
                let timestream = TimeStream.generate(.today(.harmonics))
                return timestream
            case .astroHarmonicsThisSolarCycle:
                let timestream = TimeStream.generate(.today(.harmonics))
                return timestream
            case .geoCentricGravimetrics:
                let timestream = TimeStream.generate(.today(.harmonics))
                return timestream
            case .helioCentricGravimetrics:
                let timestream = TimeStream.generate(.today(.harmonics))
                return timestream
            case .interPlanetaryGravimetrics:
                let timestream = TimeStream.generate(.today(.harmonics))
                return timestream
            }
        }
        
        func configuration() -> TimeStream.Configuration {
            let option = self.timestreamGeneratorOption
            let timestreams = [TimeStream.Generator.generate(option)]
            let configuration = TimeStream.Configuration(sampleCount: option.sampleCount,
                                                         primaryChart: nil,
                                                         secondaryChart: nil,
                                                         timeStreams: timestreams,
                                                         nodeTypes: option.nodeTypes)
            return configuration
        }
        
        var sampleCount: Int {
            return timestreamGeneratorOption.sampleCount
        }
        
        var timestreamGeneratorOption: TimeStream.Generator.Option {
            switch self {
            case .astroHarmonicsToday: return .today(.harmonics)
            case .astroHarmonicsThisMonth: return .thisMonth(.harmonics)
            case .astroHarmonicsThisYear: return .thisYear(.harmonics)
            case .astroHarmonicsThisSolarCycle: return .thisSolarCycle(.harmonics)
            case .geoCentricGravimetrics: return .earthCentric
            case .helioCentricGravimetrics: return .solarCentric
            case .interPlanetaryGravimetrics: return .interplanetaryWeb
            }
        }
    }
}

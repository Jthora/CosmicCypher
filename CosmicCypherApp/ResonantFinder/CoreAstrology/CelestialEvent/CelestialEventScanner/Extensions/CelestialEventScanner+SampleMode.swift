//
//  CelestialEventScanner+SampleMode.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/7/23.
//

import Foundation

// MARK: Sample Mode
extension CelestialEventScanner {
    // Sample Mode of Scanner
    enum SampleMode: Int, CaseIterable {
        case minute
        case hour
        case day
        
        // Console Text
        var consoleText: String {
            switch self {
            case .minute: return "Minute"
            case .hour: return "Hour"
            case .day: return "Day"
            }
        }
        // Button Text
        var segmentedControlText: String {
            switch self {
            case .minute: return "Min"
            case .hour: return "Hour"
            case .day: return "Day"
            }
        }
        // Emoji
        var emoji: String {
            switch self {
            case .minute: return "⏱️"
            case .hour: return "⏰"
            case .day: return "🗓️"
            }
        }
    }
}

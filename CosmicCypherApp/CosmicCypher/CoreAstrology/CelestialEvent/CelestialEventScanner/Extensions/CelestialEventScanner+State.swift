//
//  CelestialEventScanner+State.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/7/23.
//

import Foundation

// MARK: State
// State
extension CelestialEventScanner {
    // State of Scanner
    enum State {
        case ready
        case scanning
        case paused
        case done
        case fail
        
        var consoleText: String {
            switch self {
            case .ready: return "🟢 Ready"
            case .scanning: return "▶️ Scanning"
            case .paused: return "⏸️ Paused"
            case .done: return "✅ Done"
            case .fail: return "⚠️ Fail"
            }
        }
    }
}



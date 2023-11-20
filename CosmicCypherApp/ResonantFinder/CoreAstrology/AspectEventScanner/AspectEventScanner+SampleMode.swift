//
//  AspectEventScanner+SampleMode.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/7/23.
//

import Foundation

// MARK: Sample Mode
extension AspectEventScanner {
    // Sample Mode of Scanner
    enum SampleMode {
        case simple
        case precise
        
        var consoleText: String {
            switch self {
            case .simple: return "Simple"
            case .precise: return "Precise"
            }
        }
    }
}

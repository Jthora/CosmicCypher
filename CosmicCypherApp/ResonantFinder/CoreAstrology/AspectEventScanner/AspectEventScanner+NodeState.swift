//
//  AspectEventScanner+NodeState.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/7/23.
//

import Foundation

extension AspectEventScanner {
    class NodeState {
        var currentMotion:Motion
        
        enum Motion {
            case direct(_ momentum: Momentum)
            case retrograde(_ momentum: Momentum)
            case stationary
            
            enum Momentum {
                case constant
                case accelerating
                case deaccelerating
            }
        }
        
        init(_ initialMotion: Motion) {
            self.currentMotion = initialMotion
        }
        
        func updateMotion(_ newMotion: Motion) {
            // Implement logic to update the motion state based on new data.
            // For example, you can handle transitions between motion states.
        }
        
        func isRetrograde() -> Bool {
            if case .retrograde = currentMotion {
                return true
            } else {
                return false
            }
        }
    }
}

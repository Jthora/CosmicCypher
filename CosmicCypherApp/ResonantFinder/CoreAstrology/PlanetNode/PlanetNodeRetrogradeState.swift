//
//  PlanetNodeRetrogradeState.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/20/23.
//

import Foundation
import SwiftAA

// MARK: Planet Node Motion State
extension PlanetNodeState {
    // Direct or Retrograde State
    public class MotionState: Codable {
        public var currentMotion:Motion
        public var speed:Degree
        
        // MARK: Motion
        public enum Motion: Codable, Hashable {
            case direct(_ momentum: Momentum?)
            case retrograde(_ momentum: Momentum?)
            case stationary
            
            // MARK: Momentum
            public enum Momentum: Int, Codable, Hashable {
                case constant
                case accelerating
                case deaccelerating
            }
        }
        
        // MARK: Init
        public init(_ initialMotion: Motion, speed:Degree) {
            self.currentMotion = initialMotion
            self.speed = speed
        }
        
        // MARK: Methods
        public func updateMotion(_ newMotion: Motion) {
            // Implement logic to update the motion state based on new data.
            // For example, you can handle transitions between motion states.
        }
        
        // MARK: Accessors
        public var isRetrograde: Bool {
            if case .retrograde = currentMotion {
                return true
            } else {
                return false
            }
        }
        
        // MARK: Equatable
        public static func == (lhs: PlanetNodeState.MotionState, rhs: PlanetNodeState.MotionState) -> Bool {
            return lhs.currentMotion == lhs.currentMotion
        }
    }
}

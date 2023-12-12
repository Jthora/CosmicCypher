//
//  PlanetNodeRetrogradeState.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/20/23.
//

import Foundation
import SwiftAA

// MARK: Motion State
extension PlanetNodeState {
    // Direct or Retrograde State
    public class MotionState: Codable, Equatable {
        // MARK: Properties
        public var motion:Motion
        public var distance:Degree
        public var speed:DegreesPerSecond
        public var speedDelta:DegreesPerSecondPerSecond
        
        // MARK: Accessors
        public var time:TimeInterval {
            return distance.value*speed.value
        }
        
        // MARK: Init
        public init(_ initialMotion: Motion, speed:DegreesPerSecond, speedDelta:DegreesPerSecondPerSecond) {
            self.motion = initialMotion
            self.distance = speed
            self.speed = speed
            self.speedDelta = speedDelta
        }
        
        // MARK: Methods
        public func updateMotion(_ newMotion: Motion) {
            // Implement logic to update the motion state based on new data.
            // For example, you can handle transitions between motion states.
        }
        
        // MARK: Accessors
        public var isRetrograde: Bool {
            if case .retrograde = motion {
                return true
            } else {
                return false
            }
        }
        
        // MARK: Equatable
        public static func == (lhs: PlanetNodeState.MotionState, rhs: PlanetNodeState.MotionState) -> Bool {
            return lhs.motion == lhs.motion && lhs.speed == lhs.speed && lhs.speedDelta == rhs.speedDelta
        }
    }
}


// MARK: Retrograde Event
enum PlanetNodeRetrogradeEvent {
    case enterDirect
    case enterRetrograde
    case peakDirect
    case peakRetrogradeccc
}

// MARK: Retrograde State
enum PlanetNodeRetrogradeState {
    case direct
    case retrograde
    case stationary
    
    func motion(_ momentum: PlanetNodeState.MotionState.Motion.Momentum?) -> PlanetNodeState.MotionState.Motion {
        switch self {
        case .direct: return .direct(momentum)
        case .retrograde: return .retrograde(momentum)
        case .stationary: return .stationary
        }
    }
}

// MARK: Motion
extension PlanetNodeState.MotionState {
    // Motion
    /// DegreesPerSecond ( Velocity | Speed )
    public enum Motion: Codable, Hashable {
        case direct(_ momentum: Momentum?)
        case retrograde(_ momentum: Momentum?)
        case stationary
        // Init
        init(_ degrees: DegreesPerSecond, _ momentum: Momentum?) {
            self = Motion.from(degrees: degrees, momentum: momentum)
        }
        // From
        static func from(degrees: DegreesPerSecond, momentum: Momentum?) -> Motion {
            if degrees > 0 {
                return .direct(momentum)
            } else if degrees == 0 {
                return .stationary
            } else {
                return .retrograde(momentum)
            }
        }
        
        func retrogradeState() -> PlanetNodeRetrogradeState {
            switch self {
            case .direct: return .direct
            case .retrograde: return .retrograde
            case .stationary: return .stationary
            }
        }
    }
}

// MARK: Momentum
extension PlanetNodeState.MotionState.Motion {
    // Momentum
    /// DegreesPerSecondPerSecond ( Acceleration | Deceleration )
    public enum Momentum: Int, Codable, Hashable {
        case constant
        case accelerating
        case deaccelerating
        // Init
        init(degrees: DegreesPerSecondPerSecond) {
            self = Momentum.from(degrees: degrees)
        }
        // From
        static func from(degrees: DegreesPerSecondPerSecond) -> Momentum {
            if degrees == 0 {
                return .constant
            } else if degrees > 0 {
                return .accelerating
            } else {
                return .deaccelerating
            }
        }
    }
}

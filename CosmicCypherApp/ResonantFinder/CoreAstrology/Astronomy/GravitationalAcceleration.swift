//
//  GravitationalAcceleration.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/19/23.
//

import Foundation
import SwiftAA

public struct GravitationalAcceleration: NumericType, CustomStringConvertible {
    /// The gravitational acceleration value in m/s²
    public let value: Double
    
    /// Initializes a new GravitationalAcceleration object
    ///
    /// - Parameter value: The value of gravitational acceleration in m/s²
    public init(_ value: Double) {
        self.value = value
    }
    
    /// Converts the current gravitational acceleration to Earth's gravity units (G)
    public var inG: EarthGravity { return EarthGravity(value / EarthGravity.earthGravity.value) }
    /// Converts to Newtons of Force
    public func toNewtons(mass: Double) -> Newtons { return Newtons(value * mass) }
    /// Convert mass from pounds to slugs then to pounds-force
    public func toPoundsForce(massInPounds: Double) -> PoundForce {
        return PoundForce(value * (massInPounds / 32.174))
    }
    
    public var description: String {
        let absValue = abs(value)
        let notation: String
        if absValue >= 1_000_000 {
            notation = String(format: "%.2e", value)
        } else {
            notation = String(format: "%.2f", value)
        }
        return "\(notation) m/s²"
    }
}

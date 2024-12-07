//
//  Pounds.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/19/23.
//

import Foundation
import SwiftAA

public struct PoundForce: NumericType, CustomStringConvertible {
    /// The value of force in pound-force.
    public let value: Double
    
    /// Initializes a new PoundForce object.
    /// - Parameter value: The value of force in pound-force.
    public init(_ value: Double) {
        self.value = value
    }
    
    /// Converts the current force to Newtons.
    public var inNewtons: Newtons { return Newtons(value / poundForceToNewtonConversionFactor) }
    
    /// Description
    public var description: String {
        let absValue = abs(value)
        let notation: String
        if absValue >= 1_000_000 {
            notation = String(format: "%.2e", value)
        } else {
            notation = String(format: "%.2f", value)
        }
        return "\(notation) lbf"
    }
}

// Conversion factor from pound-force to Newtons
let poundForceToNewtonConversionFactor: Double = 4.44822 // Approximately 1 lbf ≈ 4.44822 N

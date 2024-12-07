//
//  EarthGravity.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/19/23.
//

import Foundation
import SwiftAA

public struct EarthGravity: NumericType, CustomStringConvertible {
    
    /// Earth's gravity constant in m/s²
    static let earthGravity: GravitationalAcceleration = 9.81
    
    /// The gravity value relative to Earth's gravity (9.81 m/s² is standard)
    public let value: Double
    
    /// Initializes a new Gravity object
    ///
    /// - Parameter value: The value of gravity relative to Earth's gravity
    public init(_ value: Double) {
        self.value = value
    }
    
    /// Custom String Convertable Description
    public var description: String {
        let absValue = abs(value)
        let notation: String
        if absValue >= 1_000_000 {
            notation = String(format: "%.2e", value)
        } else {
            notation = String(format: "%.2f", value)
        }
        return "\(notation) G"
    }
}

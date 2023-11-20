//
//  Newtons.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/19/23.
//

import Foundation
import SwiftAA

public struct Newtons: NumericType, CustomStringConvertible {
    /// The Newton value
    public let value: Double
    
    /// Initializes a new Newton object.
    ///
    /// - Parameter value: The value of Newton.
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
        return "\(notation) N"
    }

}

public let newtonToPoundForceConversionFactor: Double = 0.224809 // Approximately 1 Newton ≈ 0.224809 Pound-Force
public let newtonToKilogramForceConversionFactor: Double = 0.101972 // Approximately 1 Newton ≈ 0.101972 Kilogram-Force

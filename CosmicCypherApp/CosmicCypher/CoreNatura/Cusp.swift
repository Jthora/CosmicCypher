//
//  Cusp.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/13/23.
//

import Foundation
import SwiftAA

extension Arcana {
    public enum Cusp: Int, CaseIterable, Codable {
        case rebirth
        case power
        case energy
        case magic
        case oscillation
        case exposure
        case beauty
        case drama
        case revolution
        case prophecy
        case imagination
        case sensitivity

        private static let count: Double = 12

        public static func from(degree: Degree) -> Cusp {
            // Normalize degree to 0-360
            var deg = degree.value
            deg = (deg.truncatingRemainder(dividingBy: 360) + 360).truncatingRemainder(dividingBy: 360)
            
            // Apply consistent offset to match setupBase24 logic
            deg = (deg).truncatingRemainder(dividingBy: 360)
            
            // Calculate cusp index
            let index = Int(deg / 30) % Int(count)
            return Cusp(rawValue: index)!
        }

        public static func subFrom(degree: Degree) -> Cusp {
            // Normalize degree to 0-360
            var deg = degree.value
            deg = (deg.truncatingRemainder(dividingBy: 360) + 360).truncatingRemainder(dividingBy: 360)
            
            // Apply consistent offset to match setupBase24 logic
            deg = (deg).truncatingRemainder(dividingBy: 360)
            
            // Calculate main index and fractional part
            let d = deg / 30
            let fraction = d.truncatingRemainder(dividingBy: 1)
            let baseIndex = Int(d)

            // Adjust index based on fractional part
            let index: Int
            if fraction > 0.5 {
                index = (baseIndex + 1) % Int(count)
            } else {
                index = (baseIndex - 1 + Int(count)) % Int(count)
            }
            
            return Cusp(rawValue: index)!
        }
    }
}

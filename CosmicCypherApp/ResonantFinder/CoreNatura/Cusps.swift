//
//  Cusps.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/13/23.
//

import Foundation
import SwiftAA

// Base24 (12 Cusps)
extension Arcana {
    enum Cusp: Int, CaseIterable {
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
        
        static func from(degree: Degree) -> Cusp {
            var deg = degree.value+15
            if deg < 0 { deg += 360 }
            let d = ((deg).truncatingRemainder(dividingBy: 360))/30
            let i = d.truncatingRemainder(dividingBy: 12)
            let c = Cusp(rawValue: Int(i))!
            print("creating Cusp(\(c)) degree(\(degree)) deg(\(deg)) d(\(d)) i(\(i))")
            return c
        }
    }
}

//
//  Cusp.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/13/23.
//

import Foundation
import SwiftAA

// Base24 (12 Cusps)
extension Arcana {
    public enum Cusp: Int, CaseIterable {
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
        
        private static let count:Double = 12
        
        public static func from(degree: Degree) -> Cusp {
            var deg = degree.value+15
            if deg < 0 { deg += 360 }
            let d = ((deg).truncatingRemainder(dividingBy: 360))/30
            let i = d.truncatingRemainder(dividingBy: count)
            let c = Cusp(rawValue: Int(i))!
            print("creating Cusp(\(c)) degree(\(degree)) deg(\(deg)) d(\(d)) i(\(i))")
            return c
        }
        
        public static func subFrom(degree: Degree) -> Cusp {
            var deg = degree.value+15
            if deg < 0 { deg += 360 }
            let d = ((deg).truncatingRemainder(dividingBy: 360))/30
            var i = d.truncatingRemainder(dividingBy: count)
            if i < 0 { i += count }
            if i.truncatingRemainder(dividingBy: 1) > 0.5 {
                var index = abs(Int(i)+1)
                if index > Int(count)-1 { index = 0 }
                return Cusp(rawValue: index)!
            } else {
                var index = Int(i)-1
                if index < 0 { index = Int(count)-1 }
                return Cusp(rawValue: index)!
            }
        }
    }
}

//
//  CoreAstrology+GravimetricTensor.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/20/23.
//

import SwiftAA
import Foundation

// MARK: Gravimetric Tensor 
// Gravity Tensor 
/// (Localized SpaceTime Flux)
extension CoreAstrology {
    // Gravimetric Tensor
    public struct GravimetricTensor {
        
        enum Orientation {
            case geocentric /// Earth Planet Core
            case heliocentric /// Sun Stellar Core
            case unified  /// Solar Interplanetary Web
        }
        
        var x:Double
        var y:Double
        var z:Double
        
        public init(vectorNormal: Vector3, magnitude:Double) {
            x = vectorNormal.x * magnitude
            y = vectorNormal.y * magnitude
            z = vectorNormal.z * magnitude
        }
        
        public var magnitude:Double {
            return x + y + z
        }
        
        public static var empty:GravimetricTensor {
            return GravimetricTensor(vectorNormal: Vector3.empty, magnitude:0)
        }
    }
}

// MARK: Gravimetric Tensor Operators
func +=(left: inout CoreAstrology.GravimetricTensor, right: CoreAstrology.GravimetricTensor) {
    left.x += right.x
    left.y += right.y
    left.z += right.z
    left.x += right.x
}

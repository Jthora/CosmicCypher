//
//  CoreAstrology+Vector3.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/20/23.
//

import Foundation

// MARK: Vector 3
extension CoreAstrology {
    // Vector 3
    public struct Vector3 {
        let x:Double
        let y:Double
        let z:Double
        
        public init(_ x:Double, _ y:Double, _ z:Double) {
            self.x = x
            self.y = y
            self.z = z
        }
        
        public static var empty:Vector3 {
            return Vector3(0, 0, 0)
        }
    }
}

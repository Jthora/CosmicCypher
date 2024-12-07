//
//  PlanetNodePosition.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/28/23.
//

import Foundation
import SwiftAA

// MARK: Planet Node Position
/// A simple data object for Planet Node Position retention
public class PlanetNodePosition: Codable {
    let degree:Double
    let type:PlanetNodeType
}

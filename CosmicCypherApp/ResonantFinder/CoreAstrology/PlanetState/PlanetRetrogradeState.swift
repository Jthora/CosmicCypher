//
//  PlanetRetrogradeState.swift
//  StarSeer_Mk2
//
//  Created by Jordan Trana on 9/26/21.
//

import Foundation


public enum PlanetRetrogradeState: Int {
    case direct
    case retrograde
}

extension PlanetRetrogradeState: Codable {}
extension PlanetRetrogradeState: Hashable {}

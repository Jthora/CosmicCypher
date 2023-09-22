//
//  GeographicCoordinates+Extension.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/20/23.
//

import SwiftAA
import UIKit

extension GeographicCoordinates {
    var labelText:String {
        return "[\(latitude):\(longitude)]"
    }
}

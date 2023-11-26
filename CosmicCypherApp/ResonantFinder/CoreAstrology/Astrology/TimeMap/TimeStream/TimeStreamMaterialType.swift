//
//  TimeStreamMaterialType.swift
//  StarSeer_Mk2
//
//  Created by Jordan Trana on 10/9/21.
//

import Foundation

enum TimeStreamMaterialType {
    case test
    case psionicStrip(starcharts:[StarChart]) // The StarCharts may need to be pre-processed into image data first, and then just pass the UIImage
}

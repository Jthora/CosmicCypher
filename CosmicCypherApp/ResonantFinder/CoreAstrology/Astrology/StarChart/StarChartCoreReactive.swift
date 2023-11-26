//
//  StarChartCoreReactive.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/26/22.
//

import Foundation
import UIKit

protocol StarChartCoreReactive: class {
    func starChartCore(didAction action:StarChart.Core.Action)
}

extension StarChart.Core {
    
    enum Action {
        case renderStart
        case renderProgress(completion:Float)
        case renderComplete(sprite:StarChartSpriteNode)
        case renderStop
    }
}

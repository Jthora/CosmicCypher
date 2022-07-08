//
//  TimeStreamCompositeNotchSpriteNode.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 7/1/22.
//

import SpriteKit

class TimeStreamCompositeNotchSpriteNode: SKSpriteNode {
    let point:TimeStream.Point
    init(point:TimeStream.Point, size:CGSize) {
        self.point = point
        super.init(texture: nil, color: .label, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

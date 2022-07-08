//
//  CGPoint+Extension.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 7/1/22.
//

import SpriteKit

extension CGPoint {
    static func distance(p1: CGPoint, p2: CGPoint) -> CGFloat {
        let xDist: CGFloat = (p2.x - p1.x);
        let yDist: CGFloat = (p2.y - p1.y);
        let distance: CGFloat = sqrt((xDist * xDist) + (yDist * yDist));
        return distance
    }
    
    func distance(to other: CGPoint) -> CGFloat {
        CGPoint.distance(p1: self, p2: other)
    }
}

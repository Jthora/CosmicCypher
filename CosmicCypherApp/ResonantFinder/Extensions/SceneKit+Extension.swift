//
//  SceneKit+Extension.swift
//  EarthquakeFinder
//
//  Created by Jordan Trana on 8/7/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import SceneKit

extension SCNVector3 {
    static var center:SCNVector3 {
        return SCNVector3(0, 0, 0)
    }
}


extension SCNNode {
    func animate(position:SCNVector3, duration:CFTimeInterval = 0.5, animationKey:String = "defaultPositionAnimation") {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.position = position
        }
        let spin = CABasicAnimation(keyPath: "position")
        spin.fromValue = self.position
        spin.toValue = position
        spin.duration = duration
        spin.repeatCount = .zero
        spin.fillMode = .forwards
        self.addAnimation(spin, forKey: animationKey)
        CATransaction.commit()
    }
    
    func animate(rotation:SCNVector4, duration:CFTimeInterval = 0.5, animationKey:String = "defaultRotationAnimation") {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.rotation = rotation
        }
        let spin = CABasicAnimation(keyPath: "rotation")
        spin.fromValue = self.rotation
        spin.toValue = rotation
        spin.duration = duration
        spin.repeatCount = .zero
        spin.fillMode = .forwards
        self.addAnimation(spin, forKey: animationKey)
        CATransaction.commit()
    }
}

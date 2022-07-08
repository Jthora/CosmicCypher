//
//  PsionoStreamImageStrip.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 12/8/20.
//

import UIKit
import SpriteKit


struct PsionoStreamImageStrip {
    var cgImage:CGImage
    let planet:Astrology.AspectBody
    let retrograde:Bool
    let retrogradeInverted:Bool
    let solidColors:Bool
    var width = 1
    let height = 1
    
    func makeSprite(size:CGSize) -> SKSpriteNode {
        let texture = SKTexture(cgImage: cgImage)
        let sprite = SKSpriteNode(texture: texture, color: .clear, size: size)
        return sprite
    }
}

//
//  StarChartSprite.swift
//  EarthquakeFinder
//
//  Created by Jordan Trana on 8/19/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import SpriteKit
import SwiftAA

class StarChartSpriteNode:SKSpriteNode {
    static func create(imageType:StarChart.DiskImageType, maskType:StarChart.DiskMaskType, maskRotation:CGFloat = 0, size:CGSize) -> StarChartSpriteNode {
        
        let image:CGImage = imageType.cgImage
        let mask:CGImage = maskType.cgImage.imageRotatedByDegrees(degrees: maskRotation).convertToGrayScale()
        
        let masked = image.masking(mask)!
        let maskedTexture = SKTexture(cgImage: masked)
        let sprite = StarChartSpriteNode(texture: maskedTexture, color: .clear, size: size)
        sprite.position = CGPoint(x: size.width/2, y: size.height/2)
        return sprite
    }
}

//
//  CosmicAlignmentSpriteNode.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/24/22.
//

import Foundation
import SpriteKit
import SwiftAA

class CosmicAlignmentSpriteNode: SKSpriteNode {
    
    var spritesBase12:[Arcana.Zodiac:SKSpriteNode] = [:]
    var spritesBase24:[Arcana.Cusp:SKSpriteNode] = [:]
    var spritesBase36:[Arcana.Decan:SKSpriteNode] = [:]
    
    static func create(size: CGSize) -> CosmicAlignmentSpriteNode {
        let sprite = CosmicAlignmentSpriteNode(texture: nil, color: .clear, size: size)
        sprite.setup()
        return sprite
    }
    
}

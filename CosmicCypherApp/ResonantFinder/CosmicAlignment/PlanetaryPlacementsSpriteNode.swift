//
//  PlanetaryPlacementsSpriteNode.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/13/23.
//

import Foundation
import SpriteKit
import SwiftAA

class PlanetaryPlacementsSpriteNode: SKSpriteNode {
    
    var planetSpriteNodes:[CoreAstrology.AspectBody.NodeType:PlanetSpriteNode] = [:]
    
    public static func create(starChart: StarChart, selectedPlanets:[CoreAstrology.AspectBody.NodeType], size: CGSize) -> PlanetaryPlacementsSpriteNode {
        let sprite = PlanetaryPlacementsSpriteNode(texture: nil, color: .clear, size: size)
        sprite.setup(with: starChart, selectedPlanets: selectedPlanets)
        return sprite
    }
    
    public func setup(with starChart:StarChart, selectedPlanets:[CoreAstrology.AspectBody.NodeType]) {
        
        for (nodeType, alignment) in starChart.alignments {
            guard selectedPlanets.contains(nodeType) else {continue}
            // Setup Values
            var degree = alignment.longitude
            var radius:CGFloat = size.height/8
            
            // Check of any symbols are very close and need to have a radius adjustment for legibility
            let tempPlanetSpriteNodes = planetSpriteNodes
            for (_, planetSprite) in tempPlanetSpriteNodes {
                let diff = abs(planetSprite.degree! - degree)
                if diff < 5 {
                    radius = radius - 15
                }
            }
            
            // Setup Cusp Sprite and Container Sprite
            let spriteSize = CGSize(width: size.width/20, height: size.height/20)
            let planetSprite = PlanetSpriteNode.create(nodeType: nodeType, size: spriteSize, degree: degree)
            planetSprite.position = CGPoint(x: 0, y: radius)
            let containerSprite = SKSpriteNode(texture: nil, color: .clear, size: spriteSize)
            
            // Rotate Sprite
            degree += 180
            degree = Degree(degree.value.truncatingRemainder(dividingBy: 360))
            degree = 360 - degree
            containerSprite.zRotation = CGFloat(degree.inRadians.value)
            planetSprite.zRotation = CGFloat((-degree).inRadians.value)
            
            // Add Sprite
            containerSprite.addChild(planetSprite)
            self.addChild(containerSprite)
            planetSpriteNodes[nodeType] = planetSprite
        }
    }
    
}

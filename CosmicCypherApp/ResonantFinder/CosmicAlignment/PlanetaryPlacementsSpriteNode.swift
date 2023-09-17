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
    
    lazy var defaultRadius:CGFloat = size.height/2.4
    
    // MARK: Sprites
    private var planetSpriteNodes:[CoreAstrology.AspectBody.NodeType:PlanetSpriteNode] = [:]
    public func spriteNode(for nodeType: CoreAstrology.AspectBody.NodeType) -> PlanetSpriteNode? {
        return planetSpriteNodes[nodeType]
    }
    
    private var containerSpriteNodes:[CoreAstrology.AspectBody.NodeType:SKSpriteNode] = [:]
    public func containerSpriteNode(for nodeType: CoreAstrology.AspectBody.NodeType) -> SKSpriteNode? {
        return containerSpriteNodes[nodeType]
    }
    
    // MARK: Create
    public static func create(starChart: StarChart, selectedNodeTypes:[CoreAstrology.AspectBody.NodeType], size: CGSize) -> PlanetaryPlacementsSpriteNode {
        let sprite = PlanetaryPlacementsSpriteNode(texture: nil, color: .clear, size: size)
        sprite.setup(with: starChart, selectedNodeTypes: selectedNodeTypes)
        return sprite
    }
    
    // MARK: Setup
    public func setup(with starChart:StarChart, selectedNodeTypes:[CoreAstrology.AspectBody.NodeType]) {
        
        // Clear for Reset
        clear()
        
        // Setup
        for (nodeType, alignment) in starChart.alignments {
            
            // Only Selected Planets
            guard selectedNodeTypes.contains(nodeType) else {continue}
            
            // Setup Values
            var degree = alignment.longitude
            var radius:CGFloat = defaultRadius
            
            // Check of any symbols are very close and need to have a radius adjustment for legibility
            let tempPlanetSpriteNodes = planetSpriteNodes
            for (_, planetSprite) in tempPlanetSpriteNodes {
                let diff = abs(planetSprite.degree! - degree)
                if diff < 5 {
                    radius = radius + 15
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
            containerSpriteNodes[nodeType] = containerSprite
        }
    }
    
    // MARK: Update
    public func update(with starChart:StarChart, selectedNodeTypes:[CoreAstrology.AspectBody.NodeType], animate: Bool = false) {
        
        // Check if Reset Required
        let containerKeys = Set(containerSpriteNodes.keys)
        let selectedKeys = Set(selectedNodeTypes)
        guard selectedKeys.isSubset(of: containerKeys) && containerKeys.isSubset(of: selectedKeys) else {
            // Reset Required
            setup(with: starChart, selectedNodeTypes: selectedNodeTypes)
            return
        }
        
        // Update
        for (nodeType, alignment) in starChart.alignments {
            
            // Only Selected Planets
            guard containerSpriteNodes.keys.contains(nodeType) else {continue}
            
            // Setup Degree
            var degree = alignment.longitude
            
            var radius:CGFloat = defaultRadius
            let tempPlanetSpriteNodes = planetSpriteNodes
            for (_, planetSprite) in tempPlanetSpriteNodes {
                let diff = abs(planetSprite.degree! - degree)
                if diff < 5 {
                    radius = radius - 15
                }
            }
            
            // Rotate Sprite
            degree += 180
            degree = Degree(degree.value.truncatingRemainder(dividingBy: 360))
            degree = 360 - degree
            
            if animate {
                // Create the actions for ease-in and ease-out
                let easeInAction = SKAction.rotate(toAngle: CGFloat(degree.inRadians.value), duration: 1, shortestUnitArc: true)
                let easeOutAction = SKAction.rotate(toAngle: CGFloat((-degree).inRadians.value), duration: 1, shortestUnitArc: true)

                // Create a sequence of actions to apply ease-in followed by ease-out
                let easeInEaseOutSequence = SKAction.sequence([easeInAction, easeOutAction])

                // Run the sequence on your sprite nodes
                containerSpriteNodes[nodeType]?.run(easeInEaseOutSequence)
                planetSpriteNodes[nodeType]?.run(easeInEaseOutSequence)
            } else {
                containerSpriteNodes[nodeType]?.zRotation = CGFloat(degree.inRadians.value)
                planetSpriteNodes[nodeType]?.zRotation = CGFloat((-degree).inRadians.value)
            }
        }
    }
    
    public func clear() {
        self.removeAllChildren()
        planetSpriteNodes = [:]
        containerSpriteNodes = [:]
    }
    
}

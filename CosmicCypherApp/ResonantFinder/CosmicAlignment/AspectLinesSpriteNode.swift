//
//  AspectLinesSpriteNode.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/13/23.
//

import Foundation
import SpriteKit
import SwiftAA

class AspectLinesSpriteNode: SKSpriteNode {
    
    var aspectLineSpriteNodes:[CoreAstrology.AspectType.SymbolHash:AspectLineSpriteNode] = [:]
    var containerSpriteNodes:[CoreAstrology.AspectType.SymbolHash:SKSpriteNode] = [:]
    
    public static func create(starChart: StarChart, selectedNodeTypes:[CoreAstrology.AspectBody.NodeType], selectedAspects: [CoreAstrology.AspectRelationType], size: CGSize) -> AspectLinesSpriteNode {
        let sprite = AspectLinesSpriteNode(texture: nil, color: .clear, size: size)
        sprite.setup(with: starChart, selectedNodeTypes: selectedNodeTypes, selectedAspects: selectedAspects)
        return sprite
    }
    
    public func setup(with starChart:StarChart, selectedNodeTypes:[CoreAstrology.AspectBody.NodeType], selectedAspects:[CoreAstrology.AspectRelationType]) {
        
        // Reset
        clear()
        
        // Create Line Sprites
        for aspect in starChart.aspects {
            
            // Must be part of accepted list of aspect types
            guard selectedAspects.contains(aspect.relation.type) else {continue}
            
            // Planets
            let b1 = aspect.primaryBody.type
            let b2 = aspect.secondaryBody.type
            
            // Don't draw line if planets aren't selected for that line
            guard selectedNodeTypes.contains(b1) && selectedNodeTypes.contains(b2) else {continue}
            
            // Setup Degrees for Planets 1 and 2
            guard let l1 = starChart.alignments[b1]?.longitude,
                  let l2 = starChart.alignments[b2]?.longitude else {
                print("⚠️ Longitude Missing")
                return
            }
            
            // Orb Strength
            let orbStrength = aspect.orbStrength
            
            // Radius
            let radius:CGFloat = size.height/8
            
            // Get p1 for b1 (point for body)
            let r1 = l1.inRadians
            let x1 = radius * sin(r1.value) // Calculate the X-coordinate
            let y1 = radius * cos(r1.value) // Calculate the Y-coordinate
            let p1 = CGPoint(x: x1, y: y1)
            
            // Get p2 for b2 (point for body)
            let r2 = l2.inRadians
            let x2 = radius * sin(r2.value) // Calculate the X-coordinate
            let y2 = radius * cos(r2.value) // Calculate the Y-coordinate
            let p2 = CGPoint(x: x2, y: y2)

            // Setup Cusp Sprite and Container Sprite
            let lineSprite = AspectLineSpriteNode.create(p1: p1, p2: p2, aspectType: aspect.relation.type, orbStrength: orbStrength)
            let containerSprite = SKSpriteNode(texture: nil, color: .clear, size: size)
            
            // Rotate
            containerSprite.zRotation = CGFloat(Degree(180).inRadians.value)
            
            // Add Sprite
            containerSprite.addChild(lineSprite)
            aspectLineSpriteNodes[aspect.type.hash] = lineSprite
            containerSpriteNodes[aspect.type.hash] = containerSprite
            self.addChild(containerSprite)
        }
    }
    
    public func update(with starChart:StarChart, selectedNodeTypes:[CoreAstrology.AspectBody.NodeType], selectedAspects:[CoreAstrology.AspectRelationType], animate: Bool = false) {
        
        // Check if Reset Required
        let aspectTypeHashes = Set(starChart.aspects.map({$0.type.hash}))
        let aspectLineHashes = Set(aspectLineSpriteNodes.keys)
        guard aspectTypeHashes.isSubset(of: aspectLineHashes) && aspectLineHashes.isSubset(of: aspectTypeHashes) else {
            // Reset Required
            setup(with: starChart, selectedNodeTypes: selectedNodeTypes, selectedAspects: selectedAspects)
            return
        }
        
        for aspect in starChart.aspects {
            
            // Must be part of accepted list of aspect types
            guard let aspectLineSprite = aspectLineSpriteNodes[aspect.type.hash] else {continue}
            
            // Planets
            let b1 = aspect.primaryBody.type
            let b2 = aspect.secondaryBody.type
            
            // Setup Degrees for Planets 1 and 2
            guard let l1 = starChart.alignments[b1]?.longitude,
                  let l2 = starChart.alignments[b2]?.longitude else {
                print("⚠️ Longitude Missing")
                return
            }
            
            // Orb Strength
            let orbStrength = CGFloat(aspect.orbStrength)
            
            // Radius
            let radius:CGFloat = size.height/8
            
            // Get p1 for b1 (point for body)
            let r1 = l1.inRadians
            let x1 = radius * sin(r1.value) // Calculate the X-coordinate
            let y1 = radius * cos(r1.value) // Calculate the Y-coordinate
            let p1 = CGPoint(x: x1, y: y1)
            
            // Get p2 for b2 (point for body)
            let r2 = l2.inRadians
            let x2 = radius * sin(r2.value) // Calculate the X-coordinate
            let y2 = radius * cos(r2.value) // Calculate the Y-coordinate
            let p2 = CGPoint(x: x2, y: y2)
            
            aspectLineSprite.update(p1: p1, p2: p2, orbStrength: orbStrength)
        }
    }
    
    public func clear() {
        aspectLineSpriteNodes.removeAll()
        containerSpriteNodes.removeAll()
        self.removeAllChildren()
    }
}

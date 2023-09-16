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
    
    public static func create(starChart: StarChart, selectedPlanets:[CoreAstrology.AspectBody.NodeType], selectedAspects: [CoreAstrology.AspectRelationType], size: CGSize) -> AspectLinesSpriteNode {
        let sprite = AspectLinesSpriteNode(texture: nil, color: .clear, size: size)
        sprite.setup(with: starChart, selectedPlanets: selectedPlanets, selectedAspects: selectedAspects)
        return sprite
    }
    
    public func setup(with starChart:StarChart, selectedPlanets:[CoreAstrology.AspectBody.NodeType], selectedAspects:[CoreAstrology.AspectRelationType]) {
        
        for aspect in starChart.aspects {
            
            // Must be part of accepted list of aspect types
            guard selectedAspects.contains(aspect.relation.type) else {continue}
            
            // Planets
            let b1 = aspect.primaryBody.type
            let b2 = aspect.secondaryBody.type
            
            // Don't draw line if planets aren't selected for that line
            guard selectedPlanets.contains(b1) && selectedPlanets.contains(b2) else {continue}
            
            // Setup Degrees for Planets 1 and 2
            guard var l1 = starChart.alignments[b1]?.longitude,
                  var l2 = starChart.alignments[b2]?.longitude else {
                print("⚠️ Longitude Missing")
                return
            }
            
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
            let lineSprite = AspectLineSpriteNode.create(p1: p1, p2: p2, aspectType: aspect.relation.type)
            let containerSprite = SKSpriteNode(texture: nil, color: .clear, size: size)
            
            // Rotate
            containerSprite.zRotation = CGFloat(Degree(180).inRadians.value)
            
            // Add Sprite
            containerSprite.addChild(lineSprite)
            self.addChild(containerSprite)
        }
    }
}

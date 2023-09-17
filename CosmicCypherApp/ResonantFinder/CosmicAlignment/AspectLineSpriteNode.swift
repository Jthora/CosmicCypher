//
//  AspectLineSpriteNode.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/13/23.
//

import Foundation
import SwiftAA
import SpriteKit

public class AspectLineSpriteNode: SKSpriteNode {
    
    var lineNode:SKShapeNode? = nil
    
    // Store the current p1 and p2 positions
    var currentP1: CGPoint = .zero
    var currentP2: CGPoint = .zero
    
    static func create(p1:CGPoint, p2:CGPoint, aspectType:CoreAstrology.AspectRelationType) -> AspectLineSpriteNode {
        let aspectLineSpriteNode = AspectLineSpriteNode()
        
        // Store the current positions
        aspectLineSpriteNode.currentP1 = p1
        aspectLineSpriteNode.currentP2 = p2
        
        // Create an empty shape node for the line
        let lineNode = SKShapeNode()
        lineNode.lineWidth = 2.0 // Set the line width
        
        switch aspectType {
        case .conjunction, .trine, .sextile: lineNode.strokeColor = .green
        case .opposition, .square: lineNode.strokeColor = .red
        case .oneTwelfth: lineNode.strokeColor = .blue
        default: lineNode.strokeColor = .white
        }
        
        let linePath = CGMutablePath()
        linePath.move(to: p1)
        linePath.addLine(to: p2)
        
        lineNode.path = linePath

        aspectLineSpriteNode.addChild(lineNode)
        aspectLineSpriteNode.lineNode = lineNode
        return aspectLineSpriteNode
    }
    
    // Update method to animate the line to new positions
    func update(p1: CGPoint, p2: CGPoint, animate: Bool = false) {
        // Create a new path from current positions to the new positions
        let newPath = CGMutablePath()
        newPath.move(to: currentP1)
        newPath.addLine(to: currentP2)
        
        if animate {
            // Update the lineNode's path to the new path
            let updatePathAction = SKAction.run {
                self.lineNode?.path = newPath
            }
            
            // Animate the line's movement
            let moveAnimation = SKAction.move(to: p1, duration: 0.5)
            
            // Update the current positions
            currentP1 = p1
            currentP2 = p2
            
            // Create a sequence of actions: update path and move animation
            let sequence = SKAction.sequence([updatePathAction, moveAnimation])
            
            // Run the sequence of actions
            self.run(sequence)
        } else {
            self.lineNode?.path = newPath
        }
    }
}

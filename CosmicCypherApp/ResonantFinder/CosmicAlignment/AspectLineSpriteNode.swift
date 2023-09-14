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
    
    static func create(p1:CGPoint, p2:CGPoint, aspectType:CoreAstrology.AspectRelationType) -> AspectLineSpriteNode {
        let aspectLineSpriteNode = AspectLineSpriteNode()
        
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
        return aspectLineSpriteNode
    }
}

//
//  PlanetSpriteNode.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/13/23.
//

import Foundation
import SpriteKit
import SwiftAA


public class PlanetSpriteNode: SKSpriteNode {
    
    var degree:Degree? = nil
    
    static func create(nodeType:CoreAstrology.AspectBody.NodeType, size: CGSize, degree:Degree) -> PlanetSpriteNode {
        let planetSpriteNode = PlanetSpriteNode()
        planetSpriteNode.degree = degree
        let labelNode = SKLabelNode(text: nodeType.symbol)
        labelNode.fontSize = 16
        planetSpriteNode.addChild(labelNode)
        return planetSpriteNode
    }
}

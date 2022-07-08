//
//  TimeStreamSpriteNode.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 6/2/22.
//

import Foundation
import SpriteKit

public class TimeStreamSpriteNode: SKSpriteNode {
    
    var timeStreamEffectNodes: TimeStreamEffectNodeSet = [:]
    var spriteNodes: [CoreAstrology.AspectBody.NodeType:SKSpriteNode] = [:]
    
    override init(texture: SKTexture!, color:SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(color: SKColor = .clear, size: CGSize, imageStripSet:TimeStreamImageStripSet) {
        self.init(texture: nil, color: color, size: size)
        self.spriteNodes = createSubSprites(size: size, imageStripSet: imageStripSet)
        //self.timeStreamEffectNodes = createEffectNodes(size: size, imageStripSet: imageStripSet)
        reload()
    }
    
    convenience init(color: SKColor, size: CGSize, timeStreamEffectNodes:TimeStreamEffectNodeSet) {
        self.init(texture: nil, color: color, size: size)
        self.timeStreamEffectNodes = timeStreamEffectNodes
        reload()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // reload imageStrips with new cgImages
    func reload() {
        self.removeAllChildren()
        for (planet, spriteNode) in spriteNodes {
            addChild(spriteNode)
        }
        for (planet, effectNode) in timeStreamEffectNodes {
            addChild(effectNode)
        }
    }
    
    public func createSubSprites(size: CGSize, imageStripSet: TimeStreamImageStripSet) -> [CoreAstrology.AspectBody.NodeType:SKSpriteNode] {
        
        // Setup Effect Nodes
        var spriteNodes = [CoreAstrology.AspectBody.NodeType:SKSpriteNode]()
        
        guard imageStripSet.values.count > 0 else {
            return spriteNodes
        }
        
        // Calculate X,Y,Size
        let factoredHeight: CGFloat = CGFloat(Int(size.height/CGFloat(imageStripSet.values.count)))
        let factoredSize = CGSize(width: size.width, height: factoredHeight)
        var yOffset:CGFloat = (-size.height/2) + factoredHeight/2
        
        for (planet,imageStrip) in imageStripSet {
            
            // Top Gradient
            // Central
            // Bottom Gradient
            
            // ImageStrip Sprite with Alpha Mask
            guard let spriteNode = try? imageStrip.makeSpriteNode(size: factoredSize) else {
                continue
            }
            
            // Remember Sprites
            spriteNodes[planet] = spriteNode
            
            // Set Y Offset
            spriteNode.position.y = yOffset
            
            // Increment Y Offset
            yOffset += factoredHeight
        }
        
        return spriteNodes
    }
    
    public func createEffectNodes(size: CGSize, imageStripSet: TimeStreamImageStripSet) -> TimeStreamEffectNodeSet {
        
        // Setup Effect Nodes
        var effectNodes = TimeStreamEffectNodeSet()
        
        guard imageStripSet.values.count > 0 else {
            return effectNodes
        }
        
        //
        let factoredHeight: CGFloat = CGFloat(Int(size.height/CGFloat(imageStripSet.values.count)))
        let factoredSize = CGSize(width: size.width, height: factoredHeight)
        var yOffset:CGFloat = -size.height/2
        
        for (planet,imageStrip) in imageStripSet {
            
            // Top Gradient
            // Central
            // Bottom Gradient
            
            
            
            // ImageStrip Sprite with Alpha Mask
            guard let effectNode = try? TimeStreamEffectNode(imageStrip: imageStrip, size: factoredSize, option: .gradient(.blackToWhite(.normal))) else {
                continue
            }
            guard let spriteNode = try? imageStrip.makeSpriteNode(size: factoredSize) else {
                continue
            }
            
            effectNode.addChild(spriteNode)
            
            effectNodes[planet] = effectNode
            
            effectNode.position.y = yOffset
            yOffset += factoredHeight
        }
        
        return effectNodes
    }
}

enum TimeStreamSpriteNodeError: Error {
    case runtimeError(String)
}

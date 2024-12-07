//
//  TimeStreamImageStrip.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 12/8/20.
//


import SpriteKit


public typealias TimeStreamImageStripSet = [CoreAstrology.AspectBody.NodeType:TimeStream.ImageStrip]

// MARK: Image Strip
extension TimeStream {
    // Image Strip
    public struct ImageStrip {
        public var uiImage:UIImage
        public var cgImage:CGImage { return uiImage.cgImage! }
        
        public let nodeType:CoreAstrology.AspectBody.NodeType
        public let colorRenderMode:TimeStream.ColorRenderMode
        
        public var width = 1
        public let height = 1
        
        // MARK: Init
        init(uiImage:UIImage, nodeType: CoreAstrology.AspectBody.NodeType, colorRenderMode: TimeStream.ColorRenderMode = .colorGradient) {
            self.uiImage = uiImage
            self.nodeType = nodeType
            self.colorRenderMode = colorRenderMode
        }
        
        // Make Sprite Node
        public func makeSpriteNode(size:CGSize) throws -> SKSpriteNode {
            
            let texture = SKTexture(cgImage: cgImage)
            let spriteNode = SKSpriteNode(texture: texture, color: .clear, size: size)
            //spriteNode.aspectFillToSize(fillSize: size)
            return spriteNode
        }
    }
    
}

// MARK: Render Options
extension TimeStream.ImageStrip {
    // Render Options
    public struct RenderOptions {
        public let retrograde:Bool
        public let retrogradeInverted:Bool
        public let solidColors:Bool
    }
}


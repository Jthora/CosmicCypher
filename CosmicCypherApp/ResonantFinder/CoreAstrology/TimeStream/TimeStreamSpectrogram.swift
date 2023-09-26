//
//  TimeStreamSpectrogram.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/23/23.
//

import Foundation
import MetalKit

public class TimeStreamSpectrogram {
    
    // Properties
    public var metalView:MTKView
    public var renderer:TimeStream.MetalRenderer
    public var pixelDrawer:TimeStreamPixelDrawer
    
    // Init
    public init(metalView: MTKView) {
        
        // Properties
        self.metalView = metalView
        
        // Setup Renderer
        self.renderer = TimeStream.MetalRenderer(view: self.metalView)
        self.metalView.delegate = renderer
        self.renderer.setup()
        
        // Setup Pixel Drawer
        self.pixelDrawer = TimeStreamPixelDrawer(renderer: renderer)
    }
    
    // Render
    public func render(timeStream:TimeStream,
                       selectedNodeTypes:[CoreAstrology.AspectBody.NodeType],
                       onComplete:((_ starCharts:[StarChart])->Void)? = nil,
                       onProgress:((_ completion:Double, _ starChart:StarChart?)->Void)? = nil) {
        self.pixelDrawer.render(timeStream: timeStream,
                                selectedNodeTypes: selectedNodeTypes) { starCharts in
            onComplete?(starCharts)
        } onProgress: { completion, starChart in
            onProgress?(completion, starChart)
        }
    }
}

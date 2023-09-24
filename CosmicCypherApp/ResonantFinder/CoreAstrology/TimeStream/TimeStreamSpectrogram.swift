//
//  TimeStreamSpectrogram.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/23/23.
//

import Foundation
import MetalKit

public class TimeStreamSpectrogram {
    
    public var timeStream:TimeStream
    public var metalView:MTKView
    public var selectedNodeTypes:[CoreAstrology.AspectBody.NodeType]
    
    public var renderer:TimeStream.MetalRenderer
    public var pixelDrawer:TimeStreamPixelDrawer
    
    public init(timeStream: TimeStream, metalView: MTKView, selectedNodeTypes: [CoreAstrology.AspectBody.NodeType]) {
        
        // Properties
        self.timeStream = timeStream
        self.selectedNodeTypes = selectedNodeTypes
        self.metalView = metalView
        
        // Setup Renderer
        self.renderer = TimeStream.MetalRenderer(view: self.metalView)
        self.pixelDrawer = TimeStreamPixelDrawer(timeStream: timeStream, renderer: renderer, selectedNodeTypes: selectedNodeTypes)
        self.metalView.delegate = renderer
        self.renderer.setup()
    }
    
    public func render(onComplete:((_ starCharts:[StarChart])->Void)? = nil, onProgress:((_ completion:Double, _ starChart:StarChart?)->Void)? = nil) {
        self.pixelDrawer.render { starCharts in
            onComplete?(starCharts)
        } onProgress: { completion, starChart in
            onProgress?(completion, starChart)
        }
    }
}

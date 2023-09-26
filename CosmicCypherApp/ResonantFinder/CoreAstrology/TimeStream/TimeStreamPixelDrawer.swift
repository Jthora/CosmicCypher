//
//  TimeStreamPixelDrawer.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/23/23.
//

import Foundation
import Metal


public class TimeStreamPixelDrawer {
    
    // Properties
    public var renderer:TimeStream.MetalRenderer
    
    // Init
    public init(renderer: TimeStream.MetalRenderer) {
        self.renderer = renderer
    }
    
    // Render
    public func render(timeStream:TimeStream, selectedNodeTypes:[CoreAstrology.AspectBody.NodeType], onComplete:((_ starCharts:[StarChart])->Void)? = nil, onProgress:((_ completion:Double, _ starChart:StarChart?)->Void)? = nil) {
        TimeStreamPixelDrawer.render(timeStream: timeStream,
                                     renderer: renderer,
                                     selectedNodeTypes: selectedNodeTypes,
                                     onComplete: onComplete,
                                     onProgress: onProgress)
    }
    
    // Global Render TimeStream
    public static func render(timeStream:TimeStream,
                              renderer:TimeStream.MetalRenderer,
                              selectedNodeTypes:[CoreAstrology.AspectBody.NodeType],
                              onComplete:((_ starCharts:[StarChart])->Void)? = nil,
                              onProgress:((_ completion:Double, _ starChart:StarChart?)->Void)? = nil) {
        
        guard !selectedNodeTypes.isEmpty else {return}
        let starCharts = timeStream.starCharts
        
        if starCharts.isEmpty {
            let sampleCount = timeStream.sampleCount
            var i = 0
            timeStream.loadStarCharts(sampleCount: sampleCount) { starCharts in
                onComplete?(starCharts)
            } onProgress: { completion, starChart in
                onProgress?(completion, starChart)
                guard let starChart = starChart else {return}
                for (j, nodeType) in selectedNodeTypes.enumerated() {
                    guard let alignment = starChart.alignments[nodeType] else {continue}
                    
                    let degrees = alignment.longitude
                    
                    let pixel:RGBYPixel = RGBYPixel(degrees: degrees.value, px: i, py: j)
                    renderer.draw(pixel: pixel)
                }
            }
        } else {
            render(starCharts: starCharts, renderer: renderer, selectedNodeTypes: selectedNodeTypes, onComplete: onComplete, onProgress: onProgress)
        }
    }
    
    // Global Render StarCharts
    public static func render(starCharts:[StarChart],
                              renderer:TimeStream.MetalRenderer,
                              selectedNodeTypes:[CoreAstrology.AspectBody.NodeType],
                              onComplete:((_ starCharts:[StarChart])->Void)? = nil,
                              onProgress:((_ completion:Double, _ starChart:StarChart?)->Void)? = nil) {
        
        let frameBufferWidth = starCharts.count
        let frameBufferHeight = selectedNodeTypes.count
        
        onProgress?(0, nil)
        for (i,starChart) in starCharts.enumerated() {
            for (j, nodeType) in selectedNodeTypes.enumerated() {
                guard let alignment = starChart.alignments[nodeType] else {continue}
                
                let degrees = alignment.longitude
                
                let pixel:RGBYPixel = RGBYPixel(degrees: degrees.value, px: i, py: j)
                renderer.draw(pixel: pixel)
            }
            onProgress?(0, starChart)
        }
    }
    
    public func createFrameBuffer(device:MTLDevice, width: Int, height: Int) -> TimeStreamFrameBuffer? {
        guard let device = self.renderer.device else {return nil}
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: .rgba8Unorm,
            width: width,  // Replace with your texture dimensions
            height: height, // Replace with your texture dimensions
            mipmapped: false
        )
        let framebufferTexture = device.makeTexture(descriptor: textureDescriptor)!
        return framebufferTexture
    }
}

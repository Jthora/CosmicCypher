//
//  TimeStreamPixelDrawer.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/23/23.
//

import Foundation
import Metal


class TimeStreamPixelDrawer {
    
    var timeStream:TimeStream? = nil
    var renderer:TimeStream.Composite.MetalRenderer? = nil
    var selectedNodeTypes:[CoreAstrology.AspectBody.NodeType]? = nil
    
    func setup(timeStream:TimeStream, renderer: TimeStream.Composite.MetalRenderer, selectedNodeTypes:[CoreAstrology.AspectBody.NodeType]) {
        self.timeStream = timeStream
        self.renderer = renderer
        self.selectedNodeTypes = selectedNodeTypes
    }
    
    func render(onComplete:((_ starCharts:[StarChart])->Void)? = nil, onProgress:((_ completion:Double, _ starChart:StarChart?)->Void)? = nil) {
        guard let timeStream = timeStream else {return}
        guard let renderer = renderer else {return}
        guard let selectedNodeTypes = selectedNodeTypes else {return}
        TimeStreamPixelDrawer.renderTimeStream(timeStream: timeStream, renderer: renderer, selectedNodeTypes: selectedNodeTypes, onComplete: onComplete, onProgress: onProgress)
    }
    
    static func renderTimeStream(timeStream:TimeStream, renderer:TimeStream.Composite.MetalRenderer, selectedNodeTypes:[CoreAstrology.AspectBody.NodeType], onComplete:((_ starCharts:[StarChart])->Void)? = nil, onProgress:((_ completion:Double, _ starChart:StarChart?)->Void)? = nil) {
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
    
    static func render(starCharts:[StarChart], renderer:TimeStream.Composite.MetalRenderer, selectedNodeTypes:[CoreAstrology.AspectBody.NodeType], onComplete:((_ starCharts:[StarChart])->Void)? = nil, onProgress:((_ completion:Double, _ starChart:StarChart?)->Void)? = nil) {
        
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
    
    func createFrameBuffer(device:MTLDevice, width: Int, height: Int) -> TimeStreamFrameBuffer? {
        guard let device = self.renderer?.device else {return nil}
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

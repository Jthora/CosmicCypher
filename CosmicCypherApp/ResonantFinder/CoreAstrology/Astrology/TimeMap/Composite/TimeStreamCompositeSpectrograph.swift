//
//  TimeStreamCompositeSpectrograph.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/24/23.
//

import Foundation
import Metal
import MetalKit


extension TimeStream.Composite {
    class Spectrograph {
        // Spectrographic Wrapper for TimeStream Composite
        /// Metal Shaders and Blend Modes
        /// Multiple Spectrograms and TimeStreams
        /// StarChart Personal TimeStream Overlays
        
        lazy var metalView:MTKView = MTKView(frame: .zero)
        lazy var renderer:TimeStream.Composite.MetalRenderer = TimeStream.Composite.MetalRenderer(view: metalView)
        
        var starCharts:[StarChartHashKey:StarChart] = [:]
        var spectrograms:[TimeStreamUUID:TimeStreamSpectrogram] = [:]
        var frameBuffers:[TimeStreamUUID:TimeStreamFrameBuffer] { return spectrograms.mapValues({$0.renderer.frameBuffer}) }
        
        
        // Dynamic Height
        /// Counted by Number of Planets or Nodes
        /// Spectrogram Heights must match SpectrogGraph height
        
        // Expandable
    }
}


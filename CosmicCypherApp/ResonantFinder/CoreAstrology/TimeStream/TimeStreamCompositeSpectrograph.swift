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
    class SpectroGraph {
        var spectrograms:[TimeStreamUUID:TimeStreamSpectrogram] = [:]
        var subFrameBuffers:[TimeStreamUUID:TimeStreamFrameBuffer] { return spectrograms.mapValues({$0.renderer.frameBuffer}) }
    }
}

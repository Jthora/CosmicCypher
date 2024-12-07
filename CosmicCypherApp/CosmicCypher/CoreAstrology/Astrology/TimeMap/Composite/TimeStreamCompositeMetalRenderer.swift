//
//  TimeStreamCompositeMetalRenderer.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/25/23.
//

import Metal
import MetalKit
import SpriteKit

typealias TimeStreamCompositeFrameBuffer = MTLTexture

extension TimeStream.Composite {
    class MetalRenderer: NSObject, MTKViewDelegate {
        // Metal Device and Command Queue
        public var device: MTLDevice!
        public var commandQueue: MTLCommandQueue!

        // Render Pipeline State
        private var renderPipelineState: MTLRenderPipelineState!

        // Framebuffer and Render Pass Descriptor
        private var frameBuffer: MTLTexture!
        private var renderPassDescriptor: MTLRenderPassDescriptor!
        
        // Current Spectrogram Data
        private var currentSpectrogramData: SpectrogramData?

        public var vertexBuffer: MTLBuffer!
        public var view: MTKView!
        
        // Spectrograph Data
        private var spectrographData: SpectrogramData?
        
        public init(view: MTKView) {
            super.init()
            self.view = view
            device = MTLCreateSystemDefaultDevice()
            view.device = device
            view.delegate = self
            commandQueue = device.makeCommandQueue()
            
            // Create pipeline state
            createPipelineState()
            createFrameBuffer()
        }
        
        public func createPipelineState() {
            guard let defaultLibrary = device.makeDefaultLibrary() else {
                print("Failed to load Metal default library.")
                return
            }
            
            // Load shader functions
            guard let vertexFunction = defaultLibrary.makeFunction(name: "vertexShader"),
                  let fragmentFunction = defaultLibrary.makeFunction(name: "fragmentShader") else {
                print("Failed to load vertex or fragment shader functions.")
                return
            }
            
            // Configure the pipeline descriptor
            let pipelineDescriptor = MTLRenderPipelineDescriptor()
            pipelineDescriptor.vertexFunction = vertexFunction
            pipelineDescriptor.fragmentFunction = fragmentFunction
            pipelineDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat
            pipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
            pipelineDescriptor.colorAttachments[0].rgbBlendOperation = .add
            pipelineDescriptor.colorAttachments[0].alphaBlendOperation = .add
            pipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
            pipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
            pipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .sourceAlpha
            pipelineDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
            
            // Create the pipeline state
            do {
                renderPipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
                print("Pipeline state created successfully.")
            } catch {
                print("Failed to create pipeline state: \(error)")
            }
        }
        
        public func createFrameBuffer() {
            let descriptor = MTLTextureDescriptor.texture2DDescriptor(
                pixelFormat: .rgba8Unorm,
                width: Int(view.drawableSize.width),
                height: Int(view.drawableSize.height),
                mipmapped: false
            )
            descriptor.usage = [.renderTarget, .shaderRead]

            frameBuffer = device.makeTexture(descriptor: descriptor)
            print("Frame buffer created with size: \(frameBuffer.width)x\(frameBuffer.height)")
        }
        
        public func createRenderPassDescriptor() -> MTLRenderPassDescriptor? {
            guard let drawable = view.currentDrawable else { return nil }

            let passDescriptor = MTLRenderPassDescriptor()
            passDescriptor.colorAttachments[0].texture = drawable.texture
            passDescriptor.colorAttachments[0].loadAction = .clear
            passDescriptor.colorAttachments[0].storeAction = .store
            passDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)

            return passDescriptor
        }
        
        // Method to Update Spectrogram Data
        func updateSpectrographData(_ data: SpectrogramData) {
            self.currentSpectrogramData = data
            print("MetalRenderer received updated SpectrogramData.")
        }
        
        public func draw(in view: MTKView) {
            guard let drawable = view.currentDrawable,
                  let passDescriptor = view.currentRenderPassDescriptor else { return }

            // Update the render pass descriptor
            renderPassDescriptor = passDescriptor
            renderPassDescriptor.colorAttachments[0].texture = drawable.texture
            renderPassDescriptor.colorAttachments[0].loadAction = .clear
            renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)

            // Begin rendering
            let commandBuffer = commandQueue.makeCommandBuffer()
            let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
            renderEncoder?.setRenderPipelineState(renderPipelineState)

            // Custom drawing for StarChart and Spectrograph
            renderSpectrogram(renderEncoder)

            renderEncoder?.endEncoding()
            commandBuffer?.present(drawable)
            commandBuffer?.commit()
        }
        
        private func renderSpectrogram(_ encoder: MTLRenderCommandEncoder?) {
            guard let spectrogramData = currentSpectrogramData else { return }

            // Example rendering logic (customize for your Spectrograph visuals)
            for (index, frequency) in spectrogramData.frequencies.enumerated() {
                let amplitude = spectrogramData.amplitudes[index]
                // Encode vertex data or draw calls to visualize frequency and amplitude
                print("Rendering frequency: \(frequency), amplitude: \(amplitude)")
            }
        }
        
        public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
            // Handle resizing of the drawable area if needed
        }
        
        public func draw(pixel: RGBYPixel) {
            self.draw(pixel: pixel.rgba)
        }
        
        public func draw(pixel: RGBAPixel) {
            frameBuffer.draw(pixel: pixel)
            
            // Trigger a redraw of the Metal view
            view.setNeedsDisplay()
        }

    }
}

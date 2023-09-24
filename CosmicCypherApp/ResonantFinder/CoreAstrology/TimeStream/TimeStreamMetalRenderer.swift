//
//  TimeStreamMetalRenderer.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/21/23.
//

import Metal
import MetalKit
import SpriteKit

protocol TimeStreamMetalRendererDelegate {
    
}

extension TimeStream {
    
    public typealias MetalImageStrip = MTLTexture
    public typealias MetalImageStrips = [CoreAstrology.AspectBody.NodeType:MetalImageStrip]
    
    public class MetalRenderer: NSObject, MTKViewDelegate {
        
        public var device: MTLDevice!
        public var commandQueue: MTLCommandQueue!
        public var pipelineState: MTLRenderPipelineState!
        public var vertexBuffer: MTLBuffer!
        public var frameBuffer: TimeStreamFrameBuffer!
        public var renderPassDescriptor: MTLRenderPassDescriptor!
        public var view: MTKView!
        
        public init(view: MTKView) {
            super.init()
            self.view = view
            device = MTLCreateSystemDefaultDevice()
            view.device = device
            view.delegate = self
            commandQueue = device.makeCommandQueue()
        }
        
        public func setup() {
            
            //createPipelineState()
            createFrameBuffer()
            createRenderPassDescriptor()
        }
        
        public func createPipelineState() {
            // Create a Metal shader pipeline state
            // Load and compile your vertex and fragment shaders here
            // Create a pipeline descriptor and set shader functions
            
            // Example:
            // Path to your .metal file
            let shaderFilePath = Bundle.main.path(forResource: "Shaders", ofType: "metal")
            guard let library = try? device.makeLibrary(filepath: shaderFilePath!) else {
                fatalError("Failed to load Metal library")
            }
            
            let vertexFunction = library.makeFunction(name: "vertex_main")
            let fragmentFunction = library.makeFunction(name: "fragment_main")
            
            let pipelineDescriptor = MTLRenderPipelineDescriptor()
            pipelineDescriptor.vertexFunction = vertexFunction
            pipelineDescriptor.fragmentFunction = fragmentFunction
            // Configure other pipeline settings
            
            do {
                pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
            } catch {
                fatalError("Failed to create pipeline state: \(error)")
            }
        }
        
        public func createFrameBuffer() {
            // Create a Metal texture as a frame buffer
            // Configure its size and format
            
            // Example:
            let frameBufferDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm,
                                                                                 width: Int(view.drawableSize.width),
                                                                                 height: Int(view.drawableSize.height),
                                                                                 mipmapped: false)
            frameBuffer = device.makeTexture(descriptor: frameBufferDescriptor)
        }
        
        public func createRenderPassDescriptor() {
            renderPassDescriptor = MTLRenderPassDescriptor()
            // Configure color attachment and clear color if needed
            renderPassDescriptor.colorAttachments[0].texture = frameBuffer
            renderPassDescriptor.colorAttachments[0].loadAction = .clear
            renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            renderPassDescriptor.colorAttachments[0].storeAction = .store
        }
        
        public func draw(in view: MTKView) {
            // Perform drawing operations
            
            guard let commandBuffer = commandQueue.makeCommandBuffer(),
                  let renderPassDescriptor = view.currentRenderPassDescriptor,
                  let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
                return
            }
            
            //renderEncoder.setRenderPipelineState(pipelineState)
            
            // Configure vertex and fragment buffers
            
            // Example: configure vertex and fragment buffers here
            
            // Issue drawing commands here
            
            renderEncoder.endEncoding()
            if let drawable = view.currentDrawable {
                commandBuffer.present(drawable)
            }
            commandBuffer.commit()
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

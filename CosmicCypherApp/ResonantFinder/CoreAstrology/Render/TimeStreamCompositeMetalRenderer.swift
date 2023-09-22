//
//  TimeStreamCompositeMetalRenderer.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 9/21/23.
//

import Metal
import MetalKit
import SpriteKit

extension TimeStream.Composite {
    
    typealias MetalImageStrip = MTLTexture
    typealias MetalImageStrips = [CoreAstrology.AspectBody.NodeType:MetalImageStrip]
    
    class MetalRenderer: NSObject, MTKViewDelegate {
        
        var device: MTLDevice!
        var commandQueue: MTLCommandQueue!
        var pipelineState: MTLRenderPipelineState!
        var vertexBuffer: MTLBuffer!
        var frameBuffer: MTLTexture!
        var renderPassDescriptor: MTLRenderPassDescriptor!
        var view: MTKView!
        
        init(view: MTKView) {
            super.init()
            self.view = view
            device = MTLCreateSystemDefaultDevice()
            view.device = device
            view.delegate = self
            commandQueue = device.makeCommandQueue()
        }
        
        func setup() {
            
            //createPipelineState() Fuckin Shitty ass dump fucks can't make a god damn basic default shader library work. You think you can do it? fuckin figure it out yourself shitface.
            createFrameBuffer()
            createRenderPassDescriptor()
        }
        
        func createPipelineState() {
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
        
        func createFrameBuffer() {
            // Create a Metal texture as a frame buffer
            // Configure its size and format
            
            // Example:
            let frameBufferDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm,
                                                                                 width: Int(view.drawableSize.width),
                                                                                 height: Int(view.drawableSize.height),
                                                                                 mipmapped: false)
            frameBuffer = device.makeTexture(descriptor: frameBufferDescriptor)
        }
        
        func createRenderPassDescriptor() {
            renderPassDescriptor = MTLRenderPassDescriptor()
            // Configure color attachment and clear color if needed
            renderPassDescriptor.colorAttachments[0].texture = frameBuffer
            renderPassDescriptor.colorAttachments[0].loadAction = .clear
            renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            renderPassDescriptor.colorAttachments[0].storeAction = .store
        }
        
        func draw(in view: MTKView) {
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
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
            // Handle resizing of the drawable area if needed
        }
        
        func drawRGBA(_ rgba: RGBAPixel) {
            // Ensure that x and y coordinates are within the bounds of the frame buffer
            guard rgba.px >= 0 && rgba.px < Int(view.drawableSize.width) && rgba.py >= 0 && rgba.py < Int(view.drawableSize.height) else {
                return
            }
            
            // Create a region of size 1x1 to update only the specified pixel
            let region = MTLRegion(origin: MTLOrigin(x: rgba.px, y: rgba.py, z: 0), size: MTLSize(width: 1, height: 1, depth: 1))
            
            // Prepare the pixel data
            var pixelData = [UInt8](repeating: 0, count: 4)
            pixelData[0] = rgba.r
            pixelData[1] = rgba.g
            pixelData[2] = rgba.b
            pixelData[3] = rgba.a
            
            // Update the frame buffer with the new pixel data
            frameBuffer.replace(region: region, mipmapLevel: 0, withBytes: pixelData, bytesPerRow: 4)
            
            // Trigger a redraw of the Metal view
            view.setNeedsDisplay()
        }
    }
}

struct RGBAPixel {
    let r: UInt8
    let g: UInt8
    let b: UInt8
    let a: UInt8
    let px: Int
    let py: Int
}

struct RGBYPixel {
    let r: UInt8
    let g: UInt8
    let b: UInt8
    let y: UInt8
    let px: Int
    let py: Int
}

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
    
    // Renders the TimeStream graphically as a Spectrogram using a TimeStream FrameBuffer
    public class MetalRenderer: NSObject, MTKViewDelegate {
        
        // MARK: Properties
        public var device: MTLDevice!
        public var commandQueue: MTLCommandQueue!
        public var pipelineState: MTLRenderPipelineState!
        public var vertexBuffer: MTLBuffer!
        public var frameBuffer: TimeStreamFrameBuffer!
        public var renderPassDescriptor: MTLRenderPassDescriptor!
        public var view: MTKView!
        
        // MARK: Init
        public init(view: MTKView) {
            super.init()
            self.view = view
            device = MTLCreateSystemDefaultDevice()
            view.device = device
            view.delegate = self
            commandQueue = device.makeCommandQueue()
        }
        
        // MARK: Setup
        public func setup() {
            
            createPipelineState()
            createFrameBuffer()
            createRenderPassDescriptor()
        }
        
        public func createPipelineState() {
            // Create a Metal shader pipeline state
            if let pipelineState = timeStreamRenderPipeline(metalView: view, device: device) {
                self.pipelineState = pipelineState
                return
            }
        }
        
        // MARK: Pipeline
        // Pipeline from Shader .metal file
        fileprivate func setPipelineStateFromMetalFile() {
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
        
        // Pipeline from inline metal source code
        func timeStreamRenderPipeline(metalView:MTKView, device:MTLDevice) -> MTLRenderPipelineState? {
            /// Load and compile your vertex and fragment shaders here
            let vertexShaderFunction:MTLFunction
            let fragmentShaderFunction:MTLFunction
            do {
                guard let defaultVertexShaderFunction = try TimeStreamSpectrogram.ShaderScript.defaultShaderFunction(.vertex, device: device) else {
                    print("failure: defaultShaderFunction(.vertex)")
                    return nil
                }
                guard let defaultFragmentShaderFunction = try TimeStreamSpectrogram.ShaderScript.defaultShaderFunction(.fragment, device: device) else {
                    print("failure: defaultShaderFunction(.fragment)")
                    return nil
                }
                vertexShaderFunction = defaultVertexShaderFunction
                fragmentShaderFunction = defaultFragmentShaderFunction
            } catch {
                print("error: \(error)")
                return nil
            }
            
            // Create a Metal pipeline
            /// Create a pipeline descriptor and set shader functions
            let pipelineDescriptor = MTLRenderPipelineDescriptor()
            pipelineDescriptor.vertexFunction = vertexShaderFunction
            pipelineDescriptor.fragmentFunction = fragmentShaderFunction
            pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
            guard let pipelineState = try? device.makeRenderPipelineState(descriptor: pipelineDescriptor) else {
                print("failure: makeRenderPipelineState for descriptor: \(pipelineDescriptor)")
                return nil
            }
            return pipelineState
        }
        
        // MARK: Shader Function
        func timeStreamCompositeShaderFunction(device:MTLDevice) -> MTLFunction? {
            let shaderSource = TimeStreamSpectrogram.ShaderScript.Source.timeStreamCompositeChannelsFragmentShader
            guard let library = try? device.makeLibrary(source: shaderSource, options: nil) else {
                print("failure: timeStreamCompositeShaderFunction: makeLibrary(source: \(shaderSource),")
                return nil
            }
            guard let shaderFunction = library.makeFunction(name: "upgradedFragment") else {
                print("failure: upgradedFragment doesn't existo ci no ey nada no bien. mal. malo. ")
                return nil
            }
            return shaderFunction
        }
        
        public func createFrameBuffer() {
            // Create a Metal texture as a frame buffer
            /// Define frameBuffer size and format
            let frameBufferDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm,
                                                                                 width: Int(view.drawableSize.width),
                                                                                 height: Int(view.drawableSize.height),
                                                                                 mipmapped: false)
            /// Use descriptor to make a frameBuffer
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
            
            if let pipelineState = self.pipelineState {
                renderEncoder.setRenderPipelineState(pipelineState)
            }
            
            
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


extension TimeStream.MetalRenderer {
    enum RenderMode: Int, CaseIterable {
        case timeStream
        case composite
        case starChartOnTimeStream
        case starChartOnComposite
    }
}


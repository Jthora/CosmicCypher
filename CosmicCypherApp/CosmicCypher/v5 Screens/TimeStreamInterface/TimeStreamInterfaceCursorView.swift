//
//  TimeStreamInterfaceCursorView.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 10/15/23.
//

import UIKit
import MetalKit
import Metal

class TimeStreamInterfaceCursorView: MTKView {
    
    // Pipeline State
    var pipelineState: MTLRenderPipelineState!
    
    // Scrubber Position
    var xPosition: Float = 0.0 {
        didSet {
            self.setNeedsDisplay() // Trigger rendering
            notifyPositionUpdate()
        }
    }
    
    // Gesture Recognizer for Scrubber
    private var panGestureRecognizer: UIPanGestureRecognizer!

    // Initialization
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.device = MTLCreateSystemDefaultDevice()
        self.delegate = self
        
        // Initialize Pan Gesture Recognizer
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    // Handle Pan Gesture
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let parentView = self.superview else { return }
        
        // Get translation and calculate new xPosition
        let translation = gesture.translation(in: parentView)
        let newPosition = max(0.0, min(CGFloat(xPosition) + translation.x, parentView.frame.width))
        xPosition = Float(newPosition)
        
        // Reset translation to avoid incremental accumulation
        gesture.setTranslation(.zero, in: parentView)
        
        // Optional: Handle gesture states
        if gesture.state == .ended {
            finalizeScrubbing()
        }
    }
    
    // Notify Position Update
    private func notifyPositionUpdate() {
        let scrubberX = CGFloat(xPosition)
        
        // Ensure TimeStreamCompositeSpriteNode is properly instantiated
        let scrubberNode = TimeStreamCompositeSpriteNode(size: CGSize(width: self.frame.width, height: self.frame.height))
        
        // Update scrubber position and trigger updates
        scrubberNode.setScrubber(x: scrubberX, updateStarChart: true)
    }
    
    // Finalize Scrubbing (Optional)
    private func finalizeScrubbing() {
        print("Scrubbing finalized at position: \(xPosition)")
        // Add any additional logic needed after scrubbing ends
    }
}

extension TimeStreamInterfaceCursorView: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // Handle resizing, if necessary
    }

    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }

        // Create a render command encoder
        if let commandBuffer = device?.makeCommandQueue()?.makeCommandBuffer(),
           let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) {
            renderEncoder.setRenderPipelineState(pipelineState)

            // Pass the xPosition uniform to the shader
            renderEncoder.setFragmentBytes(&xPosition, length: MemoryLayout<Float>.stride, index: 0)

            // Perform drawing commands here
            // For example, you can clear the background color or set any other parameters

            renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
            renderEncoder.endEncoding()

            commandBuffer.present(drawable)
            commandBuffer.commit()
        }
    }
}


extension TimeStreamInterfaceCursorView {
    
    // MARK: Shader Functions
    func vertexShaderFunction(device:MTLDevice) -> MTLFunction? {
        let shaderFunctionName = "vertex_main"
        let shaderSource = Source.defaultVertexShader
        
        guard let library = try? device.makeLibrary(source: shaderSource, options: nil) else {
            print("failure: fragmentShaderFunction: makeLibrary(source: \(shaderSource),")
            return nil
        }
        guard let shaderFunction = library.makeFunction(name: shaderFunctionName) else {
            print("failure: fragmentShaderFunction: library.makeFunction(name: \(shaderFunctionName)")
            return nil
        }
        return shaderFunction
    }
    
    func fragmentShaderFunction(device:MTLDevice) -> MTLFunction? {
        let shaderFunctionName = "fragment_main"
        let shaderSource = Source.verticalWhiteLineFragmentShader
        
        guard let library = try? device.makeLibrary(source: shaderSource, options: nil) else {
            print("failure: fragmentShaderFunction: makeLibrary(source: \(shaderSource),")
            return nil
        }
        guard let shaderFunction = library.makeFunction(name: shaderFunctionName) else {
            print("failure: fragmentShaderFunction: library.makeFunction(name: \(shaderFunctionName)")
            return nil
        }
        return shaderFunction
    }
    
    // Shader Source Code
    struct Source {
        // MARK: Default Shaders
        static var defaultVertexShader:String {
            return """
#include <metal_stdlib>

using namespace metal;

// Define the vertex data structure
struct Vertex {
    float4 position [[position]];
};

// The main function of the vertex shader
vertex Vertex vertex_main(uint vertexID [[vertex_id]]) {
    Vertex outVertex;

    // Perform any necessary vertex transformations here
    // For a basic example, we pass the position through unchanged
    outVertex.position = float4(0.0, 0.0, 0.0, 1.0);

    return outVertex;
}
"""
        }
        
        // MARK: Custom Fragment Shaders
        static var verticalWhiteLineFragmentShader:String {
            return """
#include <metal_stdlib>

using namespace metal;

// Define the output fragment data structure
struct FragmentData {
    half4 color [[color(0)]];
};

// Uniform representing the X position for drawing the line
float xPosition [[buffer(0)]];

// The main function of the fragment shader
fragment FragmentData fragment_main() {
    FragmentData outFragment;

    // Calculate the column index based on the xPosition
    int columnIndex = int(xPosition);

    // Set the fragment color (RGBA), for example, a solid white color
    // only for the column specified by xPosition
    if (columnIndex == gl_FragCoord.x) {
        outFragment.color = half4(1.0, 1.0, 1.0, 1.0);
    } else {
        outFragment.color = half4(0.0, 0.0, 0.0, 0.0); // Transparent
    }

    return outFragment;
}
"""
        }
    }
}

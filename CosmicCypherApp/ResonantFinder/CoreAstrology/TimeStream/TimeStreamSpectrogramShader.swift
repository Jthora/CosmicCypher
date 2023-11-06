//
//  TimeStreamSpectrogramShader.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 10/3/23.
//

import Foundation
import Metal
import MetalKit


extension TimeStreamSpectrogram {

    
    enum ShaderType {
        case blend(_ type: BlendType)
        
        enum BlendType {
            // RGBA Standards
            case screen
            case overlay
            case lighten
            case add
            case colorburn
            
            // RGBY Standards
            case friend
            case hostile
            case family
            case foreign
        }
        
    }
        
    
    enum ShaderScript {
        enum ShaderType {
            case vertex
            case fragment
        }
        
        static func defaultShaderFunction(_ fragmentShader:ShaderType, device:MTLDevice) throws -> MTLFunction? {
            let shaderFunctionName: String
            let shaderSource: String
            
            switch fragmentShader {
            case .fragment:
                shaderFunctionName = "fragment_main"
                shaderSource = Source.defaultFragmentShader
            case .vertex:
                shaderFunctionName = "vertex_main"
                shaderSource = Source.defaultVertexShader
            }
            
            do {
                let library = try device.makeLibrary(source: shaderSource, options: nil)
                guard let shaderFunction = library.makeFunction(name: shaderFunctionName) else {
                    throw ShaderError.functionNotFound(shaderFunctionName)
                }
                return shaderFunction
            } catch ShaderError.functionNotFound(let functionName) {
                throw ShaderError.shaderFunctionNotFound(functionName)
            } catch {
                throw ShaderError.compilationError(description: error.localizedDescription)
            }
        }
        
        enum ShaderError: Error {
            case functionNotFound(String)
            case shaderFunctionNotFound(String)
            case compilationError(description: String)
        }
        
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
            static var defaultFragmentShader:String {
                return """
    #include <metal_stdlib>

    using namespace metal;

    // Define the output fragment data structure
    struct FragmentData {
        half4 color [[color(0)]];
    };

    // The main function of the fragment shader
    fragment FragmentData fragment_main() {
        FragmentData outFragment;

        // Set the fragment color (RGBA), for example, a solid white color
        outFragment.color = half4(1.0, 1.0, 1.0, 1.0);

        return outFragment;
    }
    """
            }
            
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
            
            // MARK: Custom Fragment Shaders
            static var multiplyHeightFragmentShader:String {
                return """
    #include <metal_stdlib>

    using namespace metal;

    // Texture sampler
    constexpr sampler textureSampler;

    // Vertex shader output structure
    struct VertexOut {
        float4 position [[position]];
        float2 texCoord;
    };

    // Main fragment shader
    fragment float4 multiplyHeightFragment(VertexOut in [[stage_in]],
                                           texture2d<float, access::sample> inputTexture [[texture(0)]],
                                           uint2 outSize [[buffer(0)]])
    {
        // Calculate the texture coordinates for the current fragment
        float2 texCoord = in.texCoord * float2(outSize);
        
        // Calculate the height of the input texture
        float inputHeight = inputTexture.get_width();
        
        // Calculate the Y-coordinate for sampling within the stacked texture
        float y = mod(texCoord.y, inputHeight);
        
        // Calculate the normalized coordinates for texture sampling
        float2 sampleCoord = float2(texCoord.x / float(outSize.x), y / inputHeight);
        
        // Sample the input texture
        float4 color = inputTexture.sample(textureSampler, sampleCoord);
        
        // Return the sampled color
        return color;
    }

    """
            }
            
            static var averageChannelsFragmentShader:String {
                return """
    #include <metal_stdlib>

    using namespace metal;

    // Texture sampler
    constexpr sampler textureSampler;

    // Vertex shader output structure
    struct VertexOut {
        float4 position [[position]];
        float2 texCoord;
    };

    // Main fragment shader
    fragment float4 averageChannelsFragment(VertexOut in [[stage_in]],
                                            texture2d<float, access::sample> texture0 [[texture(0)]],
                                            texture2d<float, access::sample> texture1 [[texture(1)]],
                                            uint2 outSize [[buffer(0)]])
    {
        // Calculate the texture coordinates for the current fragment
        float2 texCoord = in.texCoord * float2(outSize);
        
        // Initialize variables to store the average channel values
        float4 averageColor = float4(0.0);
        
        // Sample the input textures
        float4 color0 = texture0.sample(textureSampler, float2(texCoord.x / float(outSize.x), texCoord.y / float(outSize.y)));
        float4 color1 = texture1.sample(textureSampler, float2(texCoord.x / float(outSize.x), texCoord.y / float(outSize.y)));
        
        // Calculate the average channel values independently
        averageColor.r = (color0.r + color1.r) * 0.5; // Red channel average
        averageColor.g = (color0.g + color1.g) * 0.5; // Green channel average
        averageColor.b = (color0.b + color1.b) * 0.5; // Blue channel average
        averageColor.a = (color0.a + color1.a) * 0.5; // Alpha channel average
        
        // Return the calculated average color
        return averageColor;
    }
    """
            }
            
            static var planetaryHarmonicChannelsFragmentShader:String {
                return """
    #include <metal_stdlib>

    using namespace metal;

    // Texture sampler
    constexpr sampler textureSampler;

    // Vertex shader output structure
    struct VertexOut {
        float4 position [[position]];
        float2 texCoord;
    };

    // Main fragment shader
    fragment float4 rgbyHarmonicsToRgbaChannelsFragment(VertexOut in [[stage_in]],
                                            texture2d<float, access::sample> texture0 [[texture(0)]],
                                            texture2d<float, access::sample> texture1 [[texture(1)]],
                                            uint2 outSize [[buffer(0)]])
    {
        // Calculate the texture coordinates for the current fragment
        float2 texCoord = in.texCoord * float2(outSize);
        
        // Initialize variables to store the average channel values
        float4 averageColor = float4(0.0);
        
        // Sample the input textures
        float4 color0 = texture0.sample(textureSampler, float2(texCoord.x / float(outSize.x), texCoord.y / float(outSize.y)));
        float4 color1 = texture1.sample(textureSampler, float2(texCoord.x / float(outSize.x), texCoord.y / float(outSize.y)));
        
        // Calculate the average channel values independently
        averageColor.r = (color0.r + color1.r) * 0.5; // Red channel average
        averageColor.g = (color0.g + color1.g) * 0.5; // Green channel average
        averageColor.b = (color0.b + color1.b) * 0.5; // Blue channel average
        averageColor.a = (color0.a + color1.a) * 0.5; // Alpha channel average

        // Custom blending formula for Yellow (Y) into Green (G) and Blue (B)
        float yellowWeight = 0.5;  // Adjust the weight as needed
        float3 rgb = averageColor.rgb + (averageColor.a * yellowWeight * float3(0.0, 1.0, 1.0));
        float4 resultColor = float4(rgb, 1.0);
        
        // Return the calculated average color
        return resultColor;
    }
    """
            }
            static var timeStreamCompositeChannelsFragmentShader:String {
                return """
    #include <metal_stdlib>

    using namespace metal;

    // Texture sampler
    constexpr sampler textureSampler;

    // Vertex shader output structure
    struct VertexOut {
        float4 position [[position]];
        float2 texCoord;
    };

    // Shader parameters
    constant float yellowWeight [[buffer(1)]];

    // Main fragment shader
    fragment float4 upgradedFragment(VertexOut in [[stage_in]],
                                    texture2d<float, access::sample> inputTexture [[texture(0)]],
                                    texture2d<float, access::sample> texture0 [[texture(1)]],
                                    texture2d<float, access::sample> texture1 [[texture(2)]],
                                    uint2 outSize [[buffer(0)]])
    {
        // Calculate the texture coordinates for the current fragment
        float2 texCoord = in.texCoord * float2(outSize);

        // Calculate the height of texture0
        float inputHeight = texture0.get_width();

        // Calculate the Y-coordinate for sampling within the stacked texture
        float y = mod(texCoord.y, inputHeight);

        // Calculate the normalized coordinates for texture sampling (texture0)
        float2 sampleCoord0 = float2(texCoord.x / float(outSize.x), y / inputHeight);

        // Sample the input texture (texture0)
        float4 color0 = texture0.sample(textureSampler, sampleCoord0);

        // Sample the harmonics texture (texture1)
        float4 color1 = texture1.sample(textureSampler, float2(texCoord.x / float(outSize.x), texCoord.y / float(outSize.y)));

        // Calculate the average channel values independently
        float4 averageColor = float4(0.0);
        averageColor.r = (color0.r + color1.r) * 0.5; // Red channel average
        averageColor.g = (color0.g + color1.g) * 0.5; // Green channel average
        averageColor.b = (color0.b + color1.b) * 0.5; // Blue channel average
        averageColor.a = (color0.a + color1.a) * 0.5; // Alpha channel average

        // Custom blending formula for Yellow (Y) into Green (G) and Blue (B)
        float3 rgb = averageColor.rgb + (averageColor.a * yellowWeight * float3(0.0, 1.0, 1.0));

        // Return the final calculated color with 100% opacity
        return float4(rgb, 1.0);
    }
    """
            }
        }
        
    }
}

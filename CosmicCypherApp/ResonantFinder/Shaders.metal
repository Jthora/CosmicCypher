//
//  Shaders.metal
//  CosmicCypher
//
//  Created by Jordan Trana on 9/22/23.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
};

struct VertexOut {
    float4 position [[position]];
};

vertex VertexOut vertex_main(const VertexIn vertexIn [[stage_in]]) {
    VertexOut vertexOut;
    
    // Pass through the vertex position
    vertexOut.position = vertexIn.position;
    
    return vertexOut;
}

fragment half4 fragment_main() {
    // Set the fragment color to red (1, 0, 0, 1)
    return half4(1.0, 0.0, 0.0, 1.0);
}

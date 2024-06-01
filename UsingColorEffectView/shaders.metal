//
//  shaders.metal
//  UsingCOlorEffectView
//
//  Created by javi www on 5/29/24.
//

#include <metal_stdlib>
using namespace metal;
typedef float2 vec2;

float2x2 matrixRot(float angle) {
    float s = sin ( angle );
    float c = cos ( angle );
    float2x2 rotationMatrix = float2x2( c, -s, s, c);
    return rotationMatrix;
}

float sdSegment( vec2 p, vec2 a, vec2 b ) {
    vec2 pa = p-a, ba = b-a;
    float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
    return length( pa - ba*h );
}

[[ stitchable ]] half4 parallelLines(float2 position, half4 color, float2 size, half4 lineColor, float time, float linesMult, float2 offset, float rotValue, float intensityEdge, float idx, float animF) {
    float2 uv = float2(position.x / size.x, position.y / size.y);
    float2x2 rotMat = matrixRot(rotValue + M_PI_F);
    uv -= 0.5;
    uv = uv * rotMat;
    uv += offset;
    uv += 0.5;
    float animFactorCalc = time * animF;
    vec2 ori = vec2(0.5 + animFactorCalc, -2.0);
    vec2 mo = vec2(0.5 + animFactorCalc, 2.0);
    float intensity = sdSegment(uv, ori, mo);
    color = smoothstep(0,.1, intensityEdge * cos(linesMult*M_PI_F*2*intensity)) * lineColor;
    return color;
}

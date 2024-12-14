    extern number smoothing;
    extern vec2 texSize;  // Uniform for the texture size

    vec4 effect(vec4 color, Image tex, vec2 tex_coords, vec2 frag_coords)
    {
        vec4 texColor = Texel(tex, tex_coords);
        
        // Calculate the neighboring pixel offsets
        float alpha = texColor.a;

        // Offset values to sample neighboring pixels based on texture size
        float xOffset = 1.0 / texSize.x;
        float yOffset = 1.0 / texSize.y;

        // Sample neighboring pixels
        float left = Texel(tex, tex_coords + vec2(-xOffset, 0)).a;
        float right = Texel(tex, tex_coords + vec2(xOffset, 0)).a;
        float top = Texel(tex, tex_coords + vec2(0, -yOffset)).a;
        float bottom = Texel(tex, tex_coords + vec2(0, yOffset)).a;

        // Calculate the "edge factor" based on neighboring transparency
        float edgeFactor = max(max(left, right), max(top, bottom));

        // Smooth the alpha based on the edge factor
        float smoothAlpha = smoothstep(0.0, smoothing, alpha * edgeFactor);

        texColor.a *= smoothAlpha;

        return texColor;
    }
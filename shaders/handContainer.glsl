uniform sampler2D texture;  // The texture to sample
uniform float alpha;        // Transparency value
varying vec2 texCoord;      // Texture coordinates

vec4 effect(vec4 color, sampler2D texture, vec2 texture_coords, vec2 screen_coords)
{
    vec4 pixel = texture2D(texture, texture_coords); // Sample the texture color
    pixel.a *= alpha; // Apply transparency to the alpha channel
    return pixel;
}
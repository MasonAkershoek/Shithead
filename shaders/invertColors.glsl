uniform sampler2D texture;  // The texture to sample
varying vec2 texCoord;      // Texture coordinates

vec4 effect(vec4 color, sampler2D texture, vec2 texture_coords, vec2 screen_coords)
{
    vec4 pixel = Texel(texture, texture_coords); // Sample the texture color
    pixel.r = 1 - pixel.r;
    pixel.g = 1 - pixel.g;
    pixel.b = 1 - pixel.b;
    return pixel;
}
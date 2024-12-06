uniform sampler2D texture;  // The texture to sample
uniform float darkness;     // The factor to darken the image
varying vec2 texCoord;      // Texture coordinates

vec4 effect(vec4 color, sampler2D texture, vec2 texture_coords, vec2 screen_coords)
{
    vec4 pixel = Texel(texture, texture_coords); // Sample the texture color
    pixel.rgb *= darkness; // Multiply the RGB values by the darkness factor
    return pixel;
}
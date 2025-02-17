# Sprite
### Inheritance - [Node](engine/base/node.md) > [Moveable](engine/base/moveable.md)
---
**Sprite** This allows objects that inherite it to display a texture in the game world.

### Usage
Should never be instanciated

### Parameters
| Parameter Name | Definition |
| ----------- | ----------- |
| nx | X position to set the Sprite at |
| ny | Y position to set the Sprite at |
| newTexture | A path to an image file |

### Args
| Argument Name | Default Value | Definition |
| ----------- | ----------- | ----------- |
| NONE | NONE | NONE |

### Variables
| Variable Name | Definition |
| ----------- | ----------- |
| _Texture | The texture to be rendered to the screen when the objects draw function is called |
| _Opac | Controls the opacity of the texture |

### Functions
| Function Name | Parameters | Definition |
| ----------- | ----------- | ----------- |
| setSprite | newTexture | Sets the texture of the sprite, newTexture can be a texture variable or a path to an image |
| initSprite | NONE | Sets the width and height of the object transform to the size of the image |
| draw | NONE | Draws the texture to the screen | 
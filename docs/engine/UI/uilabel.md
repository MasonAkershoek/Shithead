# UILabel
---
**UILabel** Is a text container for any text that needs to be displayed in the game it allows for self text wraping.

### Usage
```UILabel.new( x, y, fontsize, {args} )```

### Parameters
| Parameter Name | Default Value | Definition |
| ----------- | ----------- | ----------- |
| x  | none | X position to spawn the UILabel at |
| y | none | Y position to spawn the UILabel at |
| fontsize | 20 | Font size of the text in the UILabel | 


### Args
| Argument Name | Default Value | Definition |
| ----------- | ----------- | ----------- |
| text | "Empty!" | The text to be placed in the UILabel |
| widthLimit | 10 | The length the text can be before wraping |
| color | "WHITE" | Color of the text |
| alignment | "left" | Sets where the origin of the text is from ["left" or "right"]|
| font | nil | The font used to render the text |


### Variables
| Variable Name | Definition |
| ----------- | ----------- |
| T | Class identity |
| fontSize | Holds the size the font should be rendered |
| font | Holds the font used to render the text |
| text | Holds the text the UILabel is rendering |
| alignment | Tells where the origin of the text is |
| color | Holds the color the texts is rendared |
| textGraphics | The drawable object created from the text |
| widthLimit | The width the text can be before wraping |

### Functions
| Function Name | Parameters | Definition |
| ----------- | ----------- | ----------- |
| UILabel.new | x,y,fontSize,args | UILabel constructor |
| UILabel:setText | newText |Sets or changes the current text of the UILabel |
| UILabel:setWrapLimit | newWrapLimit | Changes the width at wich the text will start wraping |
| UILabel:setAlignment | alignment | Sets the alignment type of the text ["right" or "center" or "left"] |
| UILabel:draw | none | Draws the UILabel to the screen |

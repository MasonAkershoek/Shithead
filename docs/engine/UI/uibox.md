# UIBox
---
**UIBox** is the base for every UI object in the game. It contains logic that most of the UI objects need to function properly. It should never be instanciated on its own.

### Usage
```UIBox.new( w, h, {args} )```

### Parameters
| Parameter Name | Definition |
| ----------- | ----------- |
| w |  Width to set the UIBox to  |
| h | Height to set the UIBox to |
| args | A table containing optinal configurations to the UIBox |

### Args
| Argument Name | Default Value | Definition |
| ----------- | ----------- | ----------- |
| alignment | "Vertical" | How to orginize the children of the UIBox ["Vertical" or "Horizontal] |
| content | empty | Depreciated use UIBox:addChildren() |
| positions | `{Vector.new(0,0),Vector.new(0,0)}` | A table of Vectors containing the "Active" and "Inactive" positions of the UIBox `{Vector.new(x,y),Vector.new(x,y)}`|
| borderSize | 10 | How large the border around the main box area should be |
| color | "LIGHTGRAY" | color of the main UIBox area |
| bordercolor | "DARKGRAY" | color of the border |
| drawBox | true | Wether or not to draw the box (not its children) |


### Variables
| Variable Name | Definition |
| ----------- | ----------- |
| T | Objects class identity |
| alignment | How the UIBox orginizes its children |
| positions | A table of vectors containing the "Active" and "Inactive" positions |
| active | A bool that tells if the UIBox is currently in its "active" position |
| borderSize | the size of the UIBox border |
| padding | The padding from the UIBox children to the start of the UIBox border |
| borderColor | Color of the UIBox border |
| color | Color of the main UIBox area |
| drawBox | Wether or not to draw the box (not its children) |

### Functions
| Function Name | Parameters | Definition |
| ----------- | ----------- | ----------- |
| UIBox.new | w, h, args | Object constructer |
| UIBox:setActive | none | Sets the active state of the UIBox depending on its current state |
| UIBox:HAlign | none | Aligns the children of the UIBox horizontaly inside itself |
| UIBox:VAlign | none | Aligns the children of the UIBox verticly inside itself |
| UIBox:update | dt (Delta Time) | Updates the UIBox and its children |
| UIBox:draw | none | Draws the UIBox and its children |
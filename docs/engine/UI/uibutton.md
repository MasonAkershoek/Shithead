# UIButton
---
**UIButton** 
### Usage


### Parameters
| Parameter Name | Definition |
| ----------- | ----------- |
| x | X position to spawn the UIButton at |
| y | Y position to spawn the UIButton at |
| w | Width of the UIButton |
| h | Height of the UIButton |
| args | A table containing optinal configurations |

### Args
| Argument Name | Default Value | Definition |
| ----------- | ----------- | ----------- |
| action | `function () logger:log("Empty Function") end` | A function callback to be run when the button is clicked |
| color | "RED" | Color of the button |
| text | "Empty!" | Text that is displayed on the button |
| textFontSize | 20 | Font size for the text displayed on the button |



### Variables
| Variable Name | Definition |
| ----------- | ----------- |
| T | Class identity |
| action | Holds the callback function that is run when the UIButton is pressed |
| color | Holds the current color of the UIButton |
| text | Holds the text that is being displayed on the UIButton |
| oldmousedown | Holds the last mouse press to prevent the button to be hit more than once |
| clickTimer | A timer for the clicking animation of the button |


### Functions
| Function Name | Parameters | Definition |
| ----------- | ----------- | ----------- |
| UIButton.new | x,y,w,h,args | Object constructor |
| UIButton:setTexts | newText | Changes the text of th UIButton |
| UIButton:onSelect | none | Handles mouse click logic and calls the callback |
| UIButtom:update | dt (Delta time) | Updates the UIButton and its children |
| UIButton:draw | none | Draws the UIButton and its children |

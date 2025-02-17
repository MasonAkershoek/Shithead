# Node
---
**Node** is the base for every object in the game. It contains logic that most of the objects need to function properly. It should never be instanciated on its own.

### Usage
Should never be instanciated

### Parameters
| Parameter Name | Definition |
| ----------- | ----------- |
| nx | X position to set the Node at |
| ny | Y position to set the Node at |
| args | A table holding optional configurations for the object |

### Args
| Argument Name | Default Value | Definition |
| ----------- | ----------- | ----------- |
| conf | nil | A table containing object configurations |
| T | nil | A table containing one or more of the transformation variables (x,y,w,h,r,sx,sy,skx,sky) |
| parent | nil | Holds a refrance to an object to be made this objects parent |
| functions | nil | A table containing function callbacks |


### Variables
| Argument Name | Definition |
| ----------- | ----------- |
| T  | Object identity |
| _Args | Holds args for object creation |
| _Conf | Hold object configuration |
| _Transform | Holds the object transform |
| _ClickOffset | Holds the offset from the center when mouse is clicked |
| _DeadZone | Holds the area of the object where mouse hover and click is ignored | 
| _States | Holds states that apply to all objects |
| _Parent | Holds the parent of the object |
| _Children | Holds all children of the object |
| _Functions | Holds callbacks to functions defined during runtime |

### Functions
| Function Name | Parameters | Definition |
| ----------- | ----------- | ----------- |
| getWidth | NONE | Returns the width of the Node |
| getHeight | NONE | Retruns the height of the Node |
| setSize | nw, nh | Sets the width and height of the node either may be sent as negitive to ignore changing it |
| addChildren | newChild, tag | Adds a child to the Node with an optional identifying tag |
| removeChild | child, tag | Removes a child from the Node you may either pass a refrance to the chid or use a tag |
| updateChildren | dt | Iterates through the children of the Node and calls their update function |
| setParent | newParent | Sets the Node's parent to the new parent passed as an argument |
| removeParent | NONE | Node removes its self from its parents children table and sets its parent variable to nil |
| addFunction | newFunction | Adds a function callback to the functions table |
| updateFunctions | NONE | Iterates through the functions table and calls each callback | 
| getPos | pos | Returns the position of the Node. You can spesify which point on the object you want [center, topleft, topright, bottomleft, bottomright, centerleft, centerright, centertop, centerbottom] |
| setDeadZone | deadZone | Adds a new dead zone to the Node object |
| setScale | newScale | Sets the scale of the Node |
| setPos | nx, ny | Sets the position of the node, ither parameter may be set to nil to be ignored |
| checkDeadZone | mx, my | Checks to see if the mouse position is currently within the dead zone and returns true if it is else false |
| checkMouseHover | NONE | Checks to see if the current mouse position is currently over the objects bounding box and returns true if it is else false |
| isInside | x, y | Checks to see if the provided point is within the Node's bounding box |
| update | dt | Updates the node |
| draw | NONE | Draws the node (This is only here to prevent a crash if draw ever gets called on a node) | 

# Moveable
### Inheritance - [Node](engine/base/node.md)
---
**Moveable** This object is what allaows inherited classes to move dynamicly around the game world.

### Usage
Should never be instanciated

### Parameters
| Parameter Name | Definition |
| ----------- | ----------- |
| nx | X position to set the Moveable at | 
| ny | Y position to set the Moveable at |
| args | A table holding optional configurations for the object |

### Args
| Argument Name | Default Value | Definition |
| ----------- | ----------- | ----------- |
| NONE | NONE | NONE |

### Variables
| Variable Name | Definition |
| ----------- | ----------- |
| _NextTransform | This variable is set when the object needs to move to a new location | 
| _States.move | Adds the move state to the _States table |
| _States.mouseMoveable | Adds the mouseMoveable state to the _States table |
| _MovementVector | The vector used to move he object in a straight line to its destination |
| _DistanceToDest | The distance to the objects destination | 

### Functions
| Function Name | Parameters | Definition |
| ----------- | ----------- | ----------- |
| mouseMoving | NONE | Handles the logic for moving game objects with the mouse |
| moveTo | x, y, s, r | Sets the objects destination to the arguments provided. Any of them can be passed as nill to be ignored |
| move | dt | Handles the logic for moving the object in the game world | 
# A table procedural generator!

This is a quick proof of concept of a table generator after the discussion from the procedural generation class during the [techincal art course](https://elvtr.com/course/technical-art)

## How to use
The main scene runs the TableProcGen scene. You can then press enter to generate a new table.
You can also adjust the footprint of the table through the properties of the TableProcGen node. 

## Features 
- leg meshes are automatically placed based off of the footprint
- leg and table meshes are scaled to fit the footprint
- legs can be offset from the edge

## Future work
- streamlining the process of adding leg and table meshes
    - Currently leg meshes have to be imported, added to the child of a TableLeg node, then the path has to be added to the TableProcGen node.
	- It would be better if this was automatically done by reading through files in single_leg and double_leg mesh folders then creating the scenes automatically.
- add support for connected legs/double legs
- add sub shelf features
- add support for different textures for legs and the table top
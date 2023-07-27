extends Node
class_name ObjectMetaData

# Property constants
const prop_object_id: String = "object_id"
const prop_object_description: String = "object_description"
const prop_position_x: String = "position_x"
const prop_position_y: String = "position_y"
const prop_rotation: String = "rotation"
const prop_custom_properties: String = "custom_properties"
const prop_node_kind: String = "node_kind"
const prop_node_mode: String = "node_mode"
const prop_object_index: String = "object_index"

## Object Description
@export var object_id: String = ""
## Object Description
@export var object_description: String = ""
## Custom properties for the object
@export var custom_properties: Array[ObjectCustomProperty] = []
## Object layer
@export var node_kind: SharedEnums.ObjectLayer = SharedEnums.ObjectLayer.LayerForeground
## Current object canvas mode
@export var node_mode: SharedEnums.NodeCanvasMode = SharedEnums.NodeCanvasMode.ModeDesign

## X position
var position_x: int = 0
## Y position
var position_y: int = 0
## Keeps track of the index of the node
var node_index: int = 0
## Keeps track of the index of the object within the canvas itself
var object_index: int = -1
## Holder of property values
var prop_values: Dictionary = {}


## Prepares dictionary of custom property holders
func prepare_custom_prop_dict(override: bool = false):
	for property in custom_properties:
		if prop_values.has(property):
			if override:
				set_property(property[ObjectCustomProperty.prop_prop_name], property[ObjectCustomProperty.prop_prop_value])
		else:
			set_property(property[ObjectCustomProperty.prop_prop_name], property[ObjectCustomProperty.prop_prop_value])


## Gets a property's value
func get_property(prop: String):
	if prop_values.has(prop):
		return prop_values[prop]
	
	return null


## Set's a properties value
func set_property(prop: String, value):
	prop_values[prop] = value

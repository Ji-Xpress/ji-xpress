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
const prop_prop_values: String = "prop_values"
const prop_code_functions: String = "code_functions"
const prop_code_variables: String = "code_variables"
const prop_variable_values: String = "variable_values"

## Object Description
@export var object_id: String = ""
## Object Description
@export var object_description: String = ""
## Custom properties for the object
@export var custom_properties: Array[ObjectCustomProperty] = []
## Metadata of code functions
@export var code_functions: Array[ObjectCodeFunction] = []
## Variables to be used by the coding environment
@export var code_variables: Array[ObjectCustomProperty] = []
## Object layer
@export var node_kind: SharedEnums.ObjectLayer = SharedEnums.ObjectLayer.LayerForeground
## Current object canvas mode
@export var node_mode: SharedEnums.NodeCanvasMode = SharedEnums.NodeCanvasMode.ModeDesign

## X position
var position_x: int = 0
## Y position
var position_y: int = 0
## Rotation
var rotation: int = 0
## Keeps track of the index of the node
var node_index: int = 0
## Keeps track of the index of the object within the canvas itself
var object_index: int = -1
## Holder of property values
var prop_values: Dictionary = {}
## Holder of variable values
var variable_values: Dictionary = {}


## Manually assigned the node's metadata
func assign_metadata(metadata: Dictionary):
	object_index = metadata.object_index
	rotation = metadata.rotation
	position_x = metadata.position_x
	position_y = metadata.position_y
	prop_values = metadata.custom_properties


## Prepares dictionary of custom property holders
func prepare_custom_prop_dict(override: bool = false):
	for property in custom_properties:
		var property_name: String = property[ObjectCustomProperty.prop_prop_name]
		var property_value = property[ObjectCustomProperty.prop_prop_value]
		
		if prop_values.has(property_name):
			if override:
				set_property(property_name, property_value)
		else:
			set_property(property_name, property_value)



## Prepares dictionary of code variables
func prepare_code_variable_dict(override: bool = false):
	for variable in code_variables:
		var variable_name: String = variable[ObjectCustomProperty.prop_prop_name]
		var variable_value = variable[ObjectCustomProperty.prop_prop_value]
		
		if variable_value.has(variable_name):
			if override:
				set_variable(variable_name, variable_value)
		else:
			set_variable(variable_name, variable_value)


## Gets a property's value
func get_property(prop: String):
	if prop_values.has(prop):
		return prop_values[prop]
	
	return null


## Set's a properties value
func set_property(prop: String, value, is_custom_prop: bool = true):
	if is_custom_prop:
		prop_values[prop] = value


## Gets a variable's value
func get_variable(variable: String):
	if variable_values.has(variable):
		return variable_values[variable]
	
	return null


## Set's a variable value
func set_variable(variable: String, value):
	variable_values[variable] = value

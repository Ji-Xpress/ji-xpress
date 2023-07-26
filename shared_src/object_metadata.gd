extends Node
class_name ObjectMetaData


## Object Description
@export var object_description: String = ""
## Custom properties for the object
@export var custom_properties: Array[ObjectCustomProperty] = []
## Object layer
@export var object_layer: SharedEnums.ObjectLayer = SharedEnums.ObjectLayer.LayerForeground

## Holder of property values
var prop_values: Dictionary = {}


## Gets a property's value
func get_property(prop: String):
	if prop_values.has(prop):
		return prop_values[prop]
	
	return null


## Set's a properties value
func set_property(prop: String, value):
	prop_values[prop] = value

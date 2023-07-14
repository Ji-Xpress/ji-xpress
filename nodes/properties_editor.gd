extends Control

# Node references
const property_label_node: PackedScene = preload("res://nodes/property_nodes/property_label.tscn")
const text_property_node: PackedScene = preload("res://nodes/property_nodes/text_property.tscn")
const numeric_property_node: PackedScene = preload("res://nodes/property_nodes/numeric_property.tscn")
const dropdown_property_node: PackedScene = preload("res://nodes/property_nodes/dropdown_property.tscn")

# To identify what the properties are for
@export var property_set_id: String = ""

# Properties dictionary
var properties: Dictionary = {}

# Signals
signal property_changed(property_set_id: String, property_id: String, new_value)


## Add a property to the container
func add_property(property_id: String, property_type: SharedEnums.PropertyType, value = null):
	pass

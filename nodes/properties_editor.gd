extends Control

# Node references
const property_label_node: PackedScene = preload("res://nodes/property_nodes/property_label.tscn")
const text_property_node: PackedScene = preload("res://nodes/property_nodes/text_property.tscn")
const numeric_property_node: PackedScene = preload("res://nodes/property_nodes/numeric_property.tscn")
const dropdown_property_node: PackedScene = preload("res://nodes/property_nodes/dropdown_property.tscn")

# To identify what the properties are for
@export var property_set_id: String = ""

@onready var grid_container: GridContainer = $GridContainer

# Properties dictionary
var properties: Dictionary = {}

# Signals
signal property_changed(property_set_id: String, property_id: String, new_value)


## Used to handle when a property field changes
func property_value_changed(property_id: String, value):
	emit_signal("property_changed", property_set_id, property_id, value)


## Add a property to the container
func add_property(property_id: String, property_type: SharedEnums.PropertyType, value = null):
	var prop_name: String = property_id.capitalize()
	var label_instance: Label = property_label_node.instantiate()
	label_instance.text = prop_name
	var value_control: Control = null
	
	match property_type:
		SharedEnums.PropertyType.TypeString:
			value_control = text_property_node.instantiate()
			value_control.text = str(value)
		SharedEnums.PropertyType.TypeInt:
			value_control = numeric_property_node.instantiate()
			value_control.step = 1
			value_control.value = int(value)
		SharedEnums.PropertyType.TypeFloat:
			value_control = numeric_property_node.instantiate()
			value_control.step = 0.001
			value_control.value = float(value)
		SharedEnums.PropertyType.TypeDropDown:
			value_control = dropdown_property_node.instantiate()
	
	if value_control != null:
		value_control.property_id = property_id
		value_control.connect("value_updated", Callable(self, "property_value_changed"))
		grid_container.call_deferred("add_child", label_instance)
		grid_container.call_deferred("add_child", value_control)

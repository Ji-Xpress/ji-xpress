extends Control

# Node references
const property_label_node: PackedScene = preload("res://designer_nodes/property_nodes/property_label.tscn")
const text_property_node: PackedScene = preload("res://designer_nodes/property_nodes/text_property.tscn")
const numeric_property_node: PackedScene = preload("res://designer_nodes/property_nodes/numeric_property.tscn")
const dropdown_property_node: PackedScene = preload("res://designer_nodes/property_nodes/dropdown_property.tscn")
const bool_property_node: PackedScene = preload("res://designer_nodes/property_nodes/bool_property.tscn")

# To identify what the properties are for
@export var property_set_id: String = ""

@onready var grid_container: GridContainer = $GridContainer

# Properties dictionary
var properties: Dictionary = {}

# Signals
signal property_changed(property_set_id: String, property_id: String, new_value, is_custom_property: bool)


## Used to handle when a property field changes
func property_value_changed(property_id: String, value, is_custom_property):
	emit_signal("property_changed", property_set_id, property_id, value, is_custom_property)


## Clears every property fields
func clear_all_properties():
	for property_field in grid_container.get_children():
		if not property_field is Label:
			property_field.disconnect("value_updated", Callable(self, "property_value_changed"))
		
		grid_container.remove_child(property_field)
		property_field.queue_free()


## Fill in properties
func fill_properties_for_object(game_object: Node2D):
	if game_object.has_node("ObjectMetaData"):
		clear_all_properties()
		var metadata_node: ObjectMetaData = game_object.get_node("ObjectMetaData")
		
		add_property(ObjectMetaData.prop_object_id, SharedEnums.PropertyType.TypeString, metadata_node.object_id)
		add_property(ObjectMetaData.prop_position_x, SharedEnums.PropertyType.TypeInt, game_object.position.x)
		add_property(ObjectMetaData.prop_position_y, SharedEnums.PropertyType.TypeInt, game_object.position.y)
		add_property(ObjectMetaData.prop_rotation, SharedEnums.PropertyType.TypeString, game_object.rotation_degrees)
		
		var custom_properties = metadata_node.get(ObjectMetaData.prop_custom_properties)
		
		var custom_prop_index: int = 0
		for metadata_item in custom_properties:
			var current_property = custom_properties[custom_prop_index]
			add_property(current_property.get(ObjectCustomProperty.prop_prop_name), \
				current_property.get(ObjectCustomProperty.prop_prop_type), \
				current_property.get(ObjectCustomProperty.prop_prop_value))
			
			custom_prop_index += 1


## Add a property to the container
func add_property(property_id: String, property_type: SharedEnums.PropertyType, value = null, is_custom_property: bool = false):
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
			value_control.text = prop_name
			value_control.values = value
			var popup_menu: PopupMenu = value_control.get_popup()
			
			var item_index: int = 0
			
			for item in value:
				popup_menu.add_item(value[item_index], item_index)
				item_index += 1
		SharedEnums.PropertyType.TypeBool:
			value_control = bool_property_node.instantiate()
			value_control.button_pressed = value
	
	if value_control != null:
		# Set up other props and connect signals
		value_control.property_id = property_id
		value_control.is_custom_property = is_custom_property
		value_control.connect("value_updated", Callable(self, "property_value_changed"))
		
		grid_container.call_deferred("add_child", label_instance)
		grid_container.call_deferred("add_child", value_control)
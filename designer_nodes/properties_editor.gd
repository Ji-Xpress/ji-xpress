extends GridContainer

# Node references
const property_label_node: PackedScene = preload("res://designer_nodes/property_nodes/property_label.tscn")
const text_property_node: PackedScene = preload("res://designer_nodes/property_nodes/text_property.tscn")
const numeric_property_node: PackedScene = preload("res://designer_nodes/property_nodes/numeric_property.tscn")
const dropdown_property_node: PackedScene = preload("res://designer_nodes/property_nodes/dropdown_property.tscn")
const bool_property_node: PackedScene = preload("res://designer_nodes/property_nodes/bool_property.tscn")

const prop_tracker_control_id: String = "control_id"
const prop_tracker_control_type: String = "control_type"

# To identify what the properties are for
@export var property_set_id: String = ""

# Prop control trackers
var control_tracker: Dictionary = {}

# Properties dictionary
var properties: Dictionary = {}

# Signals
signal property_changed(property_set_id: String, property_id: String, new_value, is_custom_property: bool)


## Used to handle when a property field changes
func property_value_changed(property_id: String, value, is_custom_property: bool):
	emit_signal("property_changed", property_set_id, property_id, value, is_custom_property)


## Clears every property fields
func clear_all_properties():
	control_tracker = {}
	
	for property_field in get_children():
		if not property_field is Label:
			property_field.disconnect("value_updated", Callable(self, "property_value_changed"))
		
		remove_child(property_field)
		property_field.queue_free()


## Fill in properties
func fill_properties_for_object(game_object: Node):
	if game_object.has_node("ObjectMetaData"):
		clear_all_properties()
		var metadata_node: ObjectMetaData = game_object.get_node("ObjectMetaData")
		
		# Should positional metadata be editable?
		var positional_props_readonly: bool = false
		# If the metadata states placement is static then make position and rotation read only
		if metadata_node.is_static_placement:
			positional_props_readonly = true
		
		add_property(ObjectMetaData.prop_object_id, SharedEnums.PropertyType.TypeString, metadata_node.object_id, false, true)
		add_property(ObjectMetaData.prop_position_x, SharedEnums.PropertyType.TypeInt, game_object.position.x, false, positional_props_readonly)
		add_property(ObjectMetaData.prop_position_y, SharedEnums.PropertyType.TypeInt, game_object.position.y, false, positional_props_readonly)
		add_property(ObjectMetaData.prop_rotation, SharedEnums.PropertyType.TypeInt, game_object.rotation_degrees, false, positional_props_readonly)
		
		var custom_properties = metadata_node.get(ObjectMetaData.prop_custom_properties)
		
		var custom_prop_index: int = 0
		for metadata_item in custom_properties:
			var current_property = custom_properties[custom_prop_index]
			var property_name: String = current_property.get(ObjectCustomProperty.prop_prop_name)
			var property_read_only: bool = current_property.get(ObjectCustomProperty.prop_read_only)
			
			add_property(property_name, current_property.get(ObjectCustomProperty.prop_prop_type), \
				metadata_node.get_property(property_name), true, property_read_only)
			
			custom_prop_index += 1


## Updates a single property
func update_property(property_id: String, value):
	if control_tracker.has(property_id):
		var type: SharedEnums.PropertyType = control_tracker[property_id][prop_tracker_control_type]
		var control: Control = control_tracker[property_id][prop_tracker_control_id]
		
		match type:
			SharedEnums.PropertyType.TypeString:
				control.text = str(value)
			SharedEnums.PropertyType.TypeInt:
				control.value = int(value)
			SharedEnums.PropertyType.TypeFloat:
				control.value = float(value)
			SharedEnums.PropertyType.TypeDropDown:
				control.text = str(value)
			SharedEnums.PropertyType.TypeBool:
				control.button_pressed = bool(value)


## Add a property to the container
func add_property(property_id: String, property_type: SharedEnums.PropertyType, value = null, \
	is_custom_property: bool = false, is_read_only: bool = false):
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
			value_control.button_pressed = bool(value)
	
	if value_control != null:
		# Track the control
		control_tracker[property_id] = {
			prop_tracker_control_id: value_control,
			prop_tracker_control_type: property_type
		}
		
		# Set up other props and connect signals
		value_control.property_id = property_id
		value_control.is_custom_property = is_custom_property
		value_control.is_read_only = is_read_only
		value_control.connect("value_updated", Callable(self, "property_value_changed"))
		
		call_deferred("add_child", label_instance)
		call_deferred("add_child", value_control)

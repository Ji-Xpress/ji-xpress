extends CheckBox

signal value_updated(property_id: String, new_value, is_custom_property: bool)

@export var property_id: String = ""
@export var is_custom_property: bool = false
@export var is_read_only: bool = false


# Initialize
func _ready():
	disabled = is_read_only


# Property has changed
func _on_toggled(button_pressed):
	emit_signal("value_updated", property_id, button_pressed, is_custom_property)

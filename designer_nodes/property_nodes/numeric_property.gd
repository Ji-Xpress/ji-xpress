extends SpinBox

signal value_updated(property_id: String, new_value, is_custom_property: bool)

@export var property_id: String = ""
@export var is_custom_property: bool = false


# Property has changed
func _on_value_changed(new_value):
	emit_signal("value_updated", property_id, new_value, is_custom_property)

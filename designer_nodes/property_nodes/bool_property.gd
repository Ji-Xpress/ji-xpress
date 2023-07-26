extends CheckBox

signal value_updated(property_id: String, new_value)

@export var property_id: String = ""


# Property has changed
func _on_toggled(button_pressed):
	emit_signal("value_updated", property_id, button_pressed)

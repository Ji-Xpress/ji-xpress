extends LineEdit

signal value_updated(property_id: String, new_value)

@export var property_id: String = ""


# Property has changed
func _on_text_changed(new_text):
	emit_signal("value_updated", property_id, new_text)

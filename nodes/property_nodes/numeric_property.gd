extends SpinBox

signal value_updated(property_id: String, new_value)

@export var property_id: String = ""


func _on_value_changed(value):
	emit_signal("value_updated", property_id, value)

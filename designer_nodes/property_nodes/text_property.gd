extends LineEdit

signal value_updated(property_id: String, new_value, is_custom_property: bool)

@export var property_id: String = ""
@export var is_custom_property: bool = false
@export var is_read_only: bool = false


# Initialize
func _ready():
	editable = not is_read_only


# Property has changed
func _on_text_changed(new_text):
	emit_signal("value_updated", property_id, new_text, is_custom_property)

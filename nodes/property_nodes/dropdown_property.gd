extends MenuButton

signal value_updated(property_id: String, new_value)

@export var property_id: String = ""

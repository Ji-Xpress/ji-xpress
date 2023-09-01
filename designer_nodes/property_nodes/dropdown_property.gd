extends OptionButton

signal value_updated(property_id: String, new_value, is_custom_property: bool)

@export var property_id: String = ""
@export var is_custom_property: bool = false
@export var is_read_only: bool = false

# Store of values
var values: Array = []


# When an item is pressed
func popup_index_pressed(index: int):
	text = values[index]
	emit_signal("value_updated", property_id, index, is_custom_property)


# Initalization
func _ready():
	var popup: PopupMenu = get_popup()
	popup.connect("index_pressed", Callable(self, "popup_index_pressed"))
	disabled = is_read_only
	

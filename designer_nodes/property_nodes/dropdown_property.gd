extends MenuButton

signal value_updated(property_id: String, new_value)

@export var property_id: String = ""

# Store of values
var values: Array = []

# When an item is pressed
func popup_index_pressed(index: int):
	text = values[index]
	emit_signal("value_updated", property_id, index)


# Initalization
func _ready():
	var popup: PopupMenu = get_popup()
	popup.connect("index_pressed", Callable(self, "popup_index_pressed"))

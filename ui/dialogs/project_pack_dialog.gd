extends Window

# Node references
@onready var project_pack: OptionButton = $PanelContainer/MarginContainer/VBoxContainer/ProjectPack
## Popup Menu
var popup_menu: PopupMenu = null
## Selected index
var selected_index: int = -1

## Used to send back result
signal window_result(result_string, index)


# Called when the node enters the scene tree for the first time.
func _ready():
	popup_menu = project_pack.get_popup()
	var project_packs: Dictionary = GameObjectsLoader.internal_resource_packs
	
	for pack in project_packs:
		popup_menu.add_item(pack)


# Item has been selected
func _on_project_pack_item_selected(index):
	selected_index = index


# OK button pressed
func _on_ok_button_pressed():
	if selected_index > -1:
		var item: String = GameObjectsLoader.internal_resource_packs.keys()[selected_index]
		emit_signal("window_result", item, selected_index)
		hide()
	else:
		emit_signal("window_result", null, -1)
		hide()


# Cancel button pressed
func _on_cancel_button_pressed():
	emit_signal("window_result", null, -1)
	hide()


# Close button pressed
func _on_close_requested():
	_on_cancel_button_pressed()

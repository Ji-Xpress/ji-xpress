extends Window

@onready var startup_scene_dropdown: MenuButton = $PanelContainer/MarginContainer/VBoxContainer/GridContainer/StartupSceneDropdown

var startup_scene_popup: PopupMenu = null

# Called when the node enters the scene tree for the first time.
func _ready():
	startup_scene_popup = startup_scene_dropdown.get_popup()


func _on_save_button_pressed():
	hide()


func _on_cancel_button_pressed():
	hide()


# Populate the scenes
func _on_focus_entered():
	startup_scene_popup.clear()
	
	for scene in ProjectManager.scenes:
		startup_scene_popup.add_item(scene)


# Close the window
func _on_close_requested():
	hide()

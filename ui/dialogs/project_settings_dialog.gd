extends Window

@onready var startup_scene_dropdown: MenuButton = $PanelContainer/MarginContainer/VBoxContainer/GridContainer/StartupSceneDropdown
@onready var window_width: SpinBox = $PanelContainer/MarginContainer/VBoxContainer/GridContainer/WindowWidth
@onready var window_height: SpinBox = $PanelContainer/MarginContainer/VBoxContainer/GridContainer/WindowHeight

var startup_scene_popup: PopupMenu = null


# Called when the node enters the scene tree for the first time.
func _ready():
	startup_scene_popup = startup_scene_dropdown.get_popup()
	startup_scene_popup.connect("index_pressed", func(index):
		var scene_text: String = ProjectManager.scenes[index]
		startup_scene_dropdown.text = scene_text
		ProjectManager.project_metadata[ProjectMetadata.prop_startup_scene] = scene_text
		)


func _on_save_button_pressed():
	ProjectManager.project_metadata[ProjectMetadata.prop_window_width] = window_width.value
	ProjectManager.project_metadata[ProjectMetadata.prop_window_height] = window_height.value
	ProjectManager.save_project_configuration()
	hide()


func _on_cancel_button_pressed():
	hide()


# Populate the scenes
func _on_focus_entered():
	# Show the current active scene
	var current_scene_text: String = ProjectManager.project_metadata[ProjectMetadata.prop_startup_scene]
	
	if current_scene_text != "":
		startup_scene_dropdown.text = current_scene_text
	
	# Display window width and height settings from project
	window_width.value = int(ProjectManager.project_metadata[ProjectMetadata.prop_window_width])
	window_height.value = int(ProjectManager.project_metadata[ProjectMetadata.prop_window_height])
	
	# Clear and repopulate list
	startup_scene_popup.clear()
	for scene in ProjectManager.scenes:
		startup_scene_popup.add_item(scene)


# Close the window
func _on_close_requested():
	hide()

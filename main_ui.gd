extends Control

# Constants
const canvas_ui: PackedScene = preload("res://ui/canvas_ui.tscn")
const prompt_flag_new_scene: String = "new_scene"

# Node references
@onready var tab_container: TabContainer = $PanelContainer/VBoxContainer/HSplitContainer/TabContainer
@onready var project_tree_ui: Control = $PanelContainer/VBoxContainer/HSplitContainer/ProjectTreeUI
@onready var dialogs: Control = $Dialogs

@onready var save_project_button: Button = $PanelContainer/VBoxContainer/Menu/MarginContainer/HBoxContainer/SaveProjectButton
@onready var close_project_button: Button = $PanelContainer/VBoxContainer/Menu/MarginContainer/HBoxContainer/CloseProjectButton
@onready var run_project_scene_button: Button = $PanelContainer/VBoxContainer/Menu/MarginContainer/HBoxContainer/RunProjectSceneButton
@onready var run_project_button: Button = $PanelContainer/VBoxContainer/Menu/MarginContainer/HBoxContainer/RunProjectButton

@onready var tab_switch_timer: Timer = $PanelContainer/VBoxContainer/HSplitContainer/TabSwitchTimer

## Keeps track of current open tabs
var current_open_tabs: Dictionary = {}


# Perform project save
func _on_save_project_button_pressed():
	pass # Replace with function body.


# Perform project close
func _on_close_project_button_pressed():
	pass # Replace with function body.


# We need to run the current scene
func _on_run_project_scene_button_pressed():
	pass # Replace with function body.


# We need to run the project
func _on_run_project_button_pressed():
	pass # Replace with function body.


# Create a new scene button has been pressed
func _on_project_tree_ui_create_scene_pressed():
	dialogs.show_input_prompt_dialog("Scene Name", "", prompt_flag_new_scene)


# An object has been selected from the tree
func _on_project_tree_ui_object_selected(object_name):
	pass # Replace with function body.


# A scene has been selected from the tree
func _on_project_tree_ui_scene_selected(scene_name):
	if not current_open_tabs.has(scene_name):
		# New canvas scene instance
		var new_canvas_scene: Control = canvas_ui.instantiate()
		# Track the scene name in the new control
		new_canvas_scene.scene_name = scene_name
		# Add to the tab container
		tab_container.call_deferred("add_child", new_canvas_scene)
		
		# Track the child control 
		await tab_container.child_entered_tree
		
		# Assign current tab to current file
		var tab_index: int = tab_container.get_child_count() - 1
		current_open_tabs[scene_name] = tab_index
		
		# Open as current active tab and set tab title
		tab_switch_timer.start()
		await tab_switch_timer.timeout
		
		tab_container.current_tab = tab_index
		tab_container.set_tab_title(tab_index, scene_name)
	else:
		tab_container.current_tab = current_open_tabs[scene_name]


# Input prompt dialog result invoked
func _on_dialogs_input_prompt_result(result, flag):
	match flag:
		prompt_flag_new_scene:
			if ProjectManager.create_new_scene(result):
				project_tree_ui.populate_scene_list()

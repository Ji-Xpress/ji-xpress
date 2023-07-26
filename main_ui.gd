extends Control

# Constants
const canvas_ui: PackedScene = preload("res://ui/canvas_ui.tscn")
const prompt_flag_new_scene: String = "new_scene"

# Node references
@onready var tab_container: TabContainer = $PanelContainer/VBoxContainer/HSplitContainer/TabContainer
@onready var project_tree_ui: Control = $PanelContainer/VBoxContainer/HSplitContainer/ProjectTreeUI
@onready var dialogs: Control = $Dialogs
@onready var main_ui_dialogs: Control = $MainUIDialogs

@onready var save_project_button: Button = $PanelContainer/VBoxContainer/Menu/MarginContainer/HBoxContainer/SaveProjectButton
@onready var close_project_button: Button = $PanelContainer/VBoxContainer/Menu/MarginContainer/HBoxContainer/CloseProjectButton
@onready var run_project_scene_button: Button = $PanelContainer/VBoxContainer/Menu/MarginContainer/HBoxContainer/RunProjectSceneButton
@onready var run_project_button: Button = $PanelContainer/VBoxContainer/Menu/MarginContainer/HBoxContainer/RunProjectButton

@onready var tab_switch_timer: Timer = $PanelContainer/VBoxContainer/HSplitContainer/TabSwitchTimer

## Keeps track of current open tabs
var current_open_tabs: Dictionary = {}
## Keeps track of tab control requesting an action
var requesting_tab_instance_control: Control = null


## When a game object dialog is requested
func on_game_object_dialog_requested(node_instance: Control):
	requesting_tab_instance_control = node_instance
	main_ui_dialogs.show_game_object_dialog()


# Perform project save
func _on_save_project_button_pressed():
	pass # Replace with function body.


# Perform project close
func _on_close_project_button_pressed():
	ProjectManager.clear_project_metadata()
	get_tree().change_scene_to_file("res://launcher.tscn")


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
		# Connect to game object dialog requested
		new_canvas_scene.connect("add_node_pressed", Callable(self, "on_game_object_dialog_requested"))
		
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


# Game object reference addition requested
func _on_main_ui_dialogs_game_object_window_result(game_object_reference):
	if requesting_tab_instance_control != null:
		requesting_tab_instance_control.add_game_object_url_to_canvas(game_object_reference)

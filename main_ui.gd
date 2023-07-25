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


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
	# New canvas scene instance
	var new_canvas_scene: Control = canvas_ui.instantiate()
	# Track the scene name in the new control
	new_canvas_scene.scene_name = scene_name
	# Add to the tab container
	tab_container.call_deferred("add_child", new_canvas_scene)


# Input prompt dialog result invoked
func _on_dialogs_input_prompt_result(result, flag):
	match flag:
		prompt_flag_new_scene:
			print("New Scnee: " + result)

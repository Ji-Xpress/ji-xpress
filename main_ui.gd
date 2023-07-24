extends Control

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

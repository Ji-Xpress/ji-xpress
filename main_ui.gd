extends Control

# Node references
@onready var tab_container: TabContainer = $PanelContainer/VBoxContainer/HSplitContainer/TabContainer
@onready var project_tree_ui: Control = $PanelContainer/VBoxContainer/HSplitContainer/ProjectTreeUI
@onready var dialogs: Control = $Dialogs


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Save button has been pressed
func _on_file_menu_button_save_pressed():
	pass # Replace with function body.

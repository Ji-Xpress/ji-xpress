extends Control

@onready var no_project_label: Label = $PanelContainer/MarginContainer/VBoxContainer/ProjectList/NoRecentProjects
@onready var project_list: ItemList = $PanelContainer/MarginContainer/VBoxContainer/ProjectList/ProjectList


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Item on the project List has been clicked
func _on_project_list_item_clicked(index, at_position, mouse_button_index):
	pass # Replace with function body.


# Open External Project Button clicked
func _on_open_external_project_pressed():
	pass # Replace with function body.

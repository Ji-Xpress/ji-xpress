extends Control

@onready var project_pack_dialog: Window = $ProjectPackDialog

## Project Pack Dialog result
signal project_pack_dialog_result(result_string, index)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Propegate signal
func _on_project_pack_dialog_window_result(result_string, index):
	emit_signal("project_pack_dialog_result", result_string, index)


## Displays the project pack dialog
func show_project_pack_dialog():
	project_pack_dialog.show()

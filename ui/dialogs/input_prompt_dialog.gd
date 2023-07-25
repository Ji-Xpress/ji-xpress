extends Window

# Node references
@onready var line_edit = $PanelContainer/HBoxContainer/MarginContainerTop/LineEdit
@onready var error_margin_container = $PanelContainer/HBoxContainer/MarginContainerError
@onready var error_label = $PanelContainer/HBoxContainer/MarginContainerError/Panel/Label

## Text on the line edit
@export var text: String = ""
## Tracks the specific purpose of the dialog
@export var flag: String = ""
## Tracks to see if it should only check for identifiers
@export var should_be_identifier: bool = true


## When the prompt is succesful
signal prompt_result(result: String, flag: String)
## When the prompt is cancelled
signal prompt_cancelled()


## Tries to establish if the input is valid
func process_input():
	if should_be_identifier:
		if line_edit.text.is_valid_identifier():
			error_margin_container.visible = false
			emit_signal("prompt_result", line_edit.text, flag)
			hide()
			return true
		else:
			error_margin_container.visible = true
	else:
		emit_signal("prompt_result", line_edit.text, flag)
		hide()
		
		return true
	
	return false


# OK button pressed
func _on_ok_button_pressed():
	process_input()


# Cancel button pressed
func _on_cancel_button_pressed():
	emit_signal("prompt_cancelled")
	hide()


# Close button requested
func _on_close_requested():
	emit_signal("prompt_cancelled")
	hide()


# Handle when enter and esc is pressed
func _on_line_edit_gui_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER:
			process_input()
		elif event.keycode == KEY_ESCAPE:
			emit_signal("prompt_cancelled")
			hide()


## Text for the line edit
func _on_focus_entered():
	line_edit.text = text
	size.y = min_size.y

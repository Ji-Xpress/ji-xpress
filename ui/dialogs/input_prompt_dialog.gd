extends Window

@onready var line_edit = $PanelContainer/HBoxContainer/MarginContainerTop/LineEdit
## Text on the line edit
@export var text: String = ""
## Tracks the specific purpose of the dialog
@export var flag: String = ""


## When the prompt is succesful
signal prompt_result(result: String, flag: String)
## When the prompt is cancelled
signal prompt_cancelled()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# OK button pressed
func _on_ok_button_pressed():
	emit_signal("prompt_result", line_edit.text, flag)
	hide()


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
			emit_signal("prompt_result", line_edit.text, flag)
			hide()
		elif event.keycode == KEY_ESCAPE:
			emit_signal("prompt_cancelled")
			hide()


## Text for the line edit
func _on_focus_entered():
	line_edit.text = text

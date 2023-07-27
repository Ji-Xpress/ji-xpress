extends Window

signal window_cancelled()
signal window_result(results: Dictionary)

@onready var x_snapping: SpinBox = $PanelContainer/MarginContainer/VBoxContainer/Snapping/XSnapping
@onready var y_snapping: SpinBox = $PanelContainer/MarginContainer/VBoxContainer/Snapping/YSnapping


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Close button pressed
func _on_close_requested():
	emit_signal("window_cancelled")
	hide()


# Cancel button pressed
func _on_cancel_button_pressed():
	emit_signal("window_cancelled")
	hide()


# Set settings
func _on_ok_button_pressed():
	emit_signal("window_result", {
		"x_snapping": x_snapping.value,
		"y_snapping": y_snapping.value
	})
	hide()

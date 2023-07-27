extends Window

## Canvas UI reference
const canvas_ui: PackedScene = preload("res://ui/canvas_ui.tscn")
## Scene name to play
@export var scene_name: String = ""
## Instance of the canvas to play
var canvas_ui_instance: Control = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Close button pressed
func _on_close_requested():
	canvas_ui_instance.queue_free()
	canvas_ui_instance = null
	hide()


# Create a canvas instance
func _on_focus_entered():
	canvas_ui_instance = canvas_ui.instantiate()
	canvas_ui_instance.canvas_mode = SharedEnums.NodeCanvasMode.ModeRun
	canvas_ui_instance.scene_name = scene_name
	
	call_deferred("add_child", canvas_ui_instance)

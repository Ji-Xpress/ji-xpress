extends Window

## Canvas UI reference
const canvas_ui: PackedScene = preload("res://ui/canvas_ui.tscn")
## Scene name to play
@export var scene_name: String = ""
## Instance of the canvas to play
var canvas_ui_instance: Control = null


# Load a scene
func load_scene():
	# Initialize the canvas UI
	canvas_ui_instance = canvas_ui.instantiate()
	canvas_ui_instance.canvas_mode = SharedEnums.NodeCanvasMode.ModeRun
	canvas_ui_instance.scene_name = scene_name
	canvas_ui_instance.connect("design_canvas_send_node_message", Callable(self, "on_design_canvas_node_message"))

	# Set the shared state scene name
	SharedState.current_scene = scene_name.replace(Constants.scene_extension, "")
	
	call_deferred("add_child", canvas_ui_instance)


# When a canvas node message is received
func on_design_canvas_node_message(node: Node2D, message: Dictionary):
	match message[NodeToCanvasMessages.prop_node_to_canvas_message_message_id]:
		NodeToCanvasMessages.node_to_canvas_change_scene_message:
			# Change the current scene name
			scene_name = message[NodeToCanvasMessages.prop_node_to_canvas_message_message_value]
			# Delete the current scene instance
			canvas_ui_instance.disconnect("design_canvas_send_node_message", Callable(self, "on_design_canvas_node_message"))
			remove_child(canvas_ui_instance)
			canvas_ui_instance.queue_free()
			# Load the new scene
			load_scene()


# Close button pressed
func _on_close_requested():
	canvas_ui_instance.queue_free()
	canvas_ui_instance = null
	hide()


# Create a canvas instance
func _on_focus_entered():
	load_scene()

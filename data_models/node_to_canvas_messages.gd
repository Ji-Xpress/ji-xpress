extends Node
class_name NodeToCanvasMessages

## Message ID for node to canvas messaging
const prop_node_to_canvas_message_message_id: String = "message_id"
## Message ID for node to canvas messaging
const prop_node_to_canvas_message_message_value: String = "message_value"
## Message for when we need to change scene
const node_to_canvas_change_scene_message: String = "change_scene"
## Messages for setting the canvas camera positon
const node_to_canvas_set_camera_position: String = "set_camera_position"
## Messages for setting the canvas camera positon
const node_to_canvas_enable_camera: String = "enable_camera"


## Constructs a payload used for scene change
static func construct_scene_change_message(scene_id: String):
	return {
		prop_node_to_canvas_message_message_id: node_to_canvas_change_scene_message,
		prop_node_to_canvas_message_message_value: scene_id
	}

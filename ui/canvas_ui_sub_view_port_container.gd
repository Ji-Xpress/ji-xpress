extends SubViewportContainer

## Keeps track on the main canvas UI
var canvas_ui: Control = null
## Tracks the design canvas
var design_canvas: Node2D = null
## Tracks the last mouse position on the canvas
var last_canvas_mouse_position: Vector2 = Vector2.ZERO


func _ready():
	design_canvas = get_node("SubViewport/DesignCanvas")


## Validate that we can drop data into the container
func _can_drop_data(position, data):
	return typeof(data) == TYPE_DICTIONARY and data.has(Constants.drag_node_type) and data[Constants.drag_node_type] == Constants.drag_node_type_game_object


## Drop in an instance of item
func _drop_data(position, data):
	var data_dict: Dictionary = data[Constants.drag_node_data]
	var object_url: String = ProjectManager.objects_metadata[str(data_dict[ObjectProperties.prop_object_index])][GameObjectsLoader.prop_object_url]
	var object_index: int = data_dict[ObjectProperties.prop_object_index]
	
	canvas_ui.add_game_object_url_to_canvas(object_url, object_index, -1, null, last_canvas_mouse_position)

## The Design Canvas

* The design canvas is stored in the `res://designer_nodes/design_canvas.gd` file.
* The design canvas has 3 major variables tracking which nodes are currently hovered over. These variables track nodes stored in different layers, as below:

```gdscript
## Node to store foreground nodes
@onready var foreground: Node2D = $Foreground
## Node to store background nodes
@onready var background: Node2D = $Background/Nodes
## Node to store tiles
@onready var tiles: Node2D = $Tiles

## The nodes that currently have a hover over them
var active_hover_nodes_foreground: Dictionary = {}
## The nodes that currently have a hover over them
var active_hover_nodes_tiles: Dictionary = {}
## The nodes that currently have a hover over them
var active_hover_nodes_backgound: Dictionary = {}
```

* The way hover is processed is simple. The `res://designer_nodes/canvas_mouse_hit_area.tscn` creates an instance of Area2D. The node's `input_pickable` property set to `true`. The node also has event handlers for when there are mouse clicks:

```gdscript
# Handle mouse input
func _on_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton and event.pressed and event.button_mask & MOUSE_BUTTON_MASK_LEFT):
		emit_signal("node_clicked", parent_node, parent_node.object_metadata.node_index)
	elif (event is InputEventMouseButton and not event.pressed):
		emit_signal("node_unclicked", parent_node, parent_node.object_metadata.node_index)

# Mouse entred the hit box area
func _on_mouse_entered():
	emit_signal("node_hover", parent_node, parent_node.object_metadata.node_index)


# Mouse left the hitbox area
func _on_mouse_exited():
	emit_signal("node_hover_out", parent_node, parent_node.object_metadata.node_index)
```

* Handling these events sets the active hover nodes on the canvas parent container. It also sets the current active node (handled by mouse clicks).

## Design Canvas Integration with the Canvas UI for Ji-Xpress

* The main canvas for Ji-Xpress is at `res://ui/canvas_ui.tscn`. This is the canvas experience that integrates with the Design Canvas.
* The `SubViewport` has the property `physics_object_picking` set to `true`. This allows the Area2Ds to register mouse events and report them to their parent design canvas.
* The following variables allow `canvas_ui` to function properly:

```gdscript
## Tracks the current active control
var current_active_control: Node2D = null
## Keeps track of objects within the context of the canvas
var canvas_object_tracker: Dictionary = {}
## Keeps track of the last object index
var last_object_index: int = -1
```

* This is how `canvas_object_tracker` keeps track of nodes:

```gdscript
func add_game_object_url_to_canvas(url: String, created_object_index: int = -1, created_node_metadata = null):
    
    # ...

    # Add a new object and track its index together with in the metadata
    var object_index = design_canvas.add_new_node(node_instance, node_kind, node_mode, created_object_index)
    var object_id: String = "obj_" + str(object_index)

    # ... more code

    canvas_object_tracker[str(object_index)] = ProjectManager.create_new_scene_object(scene_name, url, object_id, \
        node_position, node_instance_metadata.prop_values)

func synchronize_project_metadata():
	
    # ... more code
	
	var all_nodes = [foreground_nodes, background_nodes, tiles]
	
	for node_group in all_nodes:
		for child_node in node_group:
			var object_metadata: ObjectMetaData = child_node.object_metadata
            var object_index: int = object_metadata.object_index

            # ... more code
            
			var project_object_index: Dictionary = canvas_object_tracker[str(object_index)]

# When a node is deleted
func _on_design_canvas_node_deleted(node, object_id, node_index, node_kind):
	canvas_object_tracker.erase(str(node_index))
	
    # ... more code
```
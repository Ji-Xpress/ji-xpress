extends Control

## Script name property
@export var script_name: String = ""
## Object index
@export var object_index: int = -1

## When the tab is being closed
signal tab_close_request(node_instance: Control, scene_id: String)


# Called when the node enters the scene tree for the first time.
func _ready():
	if object_index > -1:
		var object_url = ProjectManager.objects_metadata[str(object_index)][GameObjectsLoader.prop_object_url]


# Save button has been pressed
func _on_save_scene_button_pressed():
	save_tab()


# Close button has been pressed
func _on_close_tab_button_pressed():
	save_tab()
	emit_signal("tab_close_request", self, script_name)


## Save the tab's content
func save_tab():
	pass

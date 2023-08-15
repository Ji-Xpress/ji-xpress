extends Window

# Node references
@onready var item_list: ItemList = %ItemList

# Window closed
signal window_cancelled()
## An object has been selected
signal window_result(game_object_reference: String, index: int, request_position)
## Contains references in index of game items
var game_object_references: Array[String] = []
## Set this flag to rebuild the list
var rebuild_list: bool = true
## If there is a manually requedted position
var requested_position = null


# Rebuilds the game object list
func invalidate_game_object_list():
	item_list.clear()
	game_object_references.clear()
	
	# Iterate through all object types
	for object_type in GameObjectsLoader.game_objects:
		# Iterate through all game objects in the type
		for game_object in GameObjectsLoader.game_objects[object_type]:
			var current_object: Dictionary = GameObjectsLoader.game_objects[object_type][game_object]
			game_object_references.append(current_object[GameObjectsLoader.prop_object_url])
			item_list.add_item(current_object[GameObjectsLoader.prop_description])


# Close button pressed
func _on_close_requested():
	emit_signal("window_cancelled")
	hide()


# When control receives focus
func _on_focus_entered():
	if rebuild_list:
		invalidate_game_object_list()
		rebuild_list = false


# Item was double clicked
func _on_item_list_item_activated(index):
	emit_signal("window_result", game_object_references[index], index, requested_position)
	hide()

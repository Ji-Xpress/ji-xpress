extends Tree

# Parent control instance
var parent_control: Control = null


## Set metadata for dragging an item
func _get_drag_data(_at_position: Vector2) -> Variant:
	var tree_item: TreeItem = get_selected()
	
	if tree_item != null:
		if parent_control != null:
			if tree_item.get_parent() == parent_control.objects_tree_root_item:
				var data_to_return: Dictionary = {}
				data_to_return[Constants.drag_node_type] = Constants.drag_node_type_game_object
				data_to_return[Constants.drag_node_data] = tree_item.get_metadata(0)
				return data_to_return
	
	return null

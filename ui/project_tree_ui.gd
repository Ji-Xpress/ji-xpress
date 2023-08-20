extends Control

# Constants
const scene_tree_edit_button_index: int = 1
const scene_tree_delete_button_index: int = 2

# Tree node reference
@onready var tree: Tree = $PanelContainer/VBoxContainer/MarginContainer/ScrollContainer/Tree

# Icons for tree items
@export var add_icon_texture: Texture2D
@export var delete_icon_texture: Texture2D
@export var edit_icon_texture: Texture2D

# Tree items references
var root_tree_item: TreeItem = null
var scenes_tree_root_item: TreeItem = null
var objects_tree_root_item: TreeItem = null

## When the create scene button is pressed
signal create_scene_pressed()
## When a scene by that specific name is selected
signal scene_selected(scene_name: String)
## When an object with that specific name is selected
signal object_selected(metdata)
## When a scene delete request is raised
signal scene_delete_request(scene_index: int, scene_name: String)
## When a scene rename request is raised
signal scene_rename_request(scene_index: int, scene_name: String)


# Called when the node enters the scene tree for the first time.
func _ready():
	# Hide the root element
	tree.hide_root = true
	
	# Create the root element
	root_tree_item = tree.create_item()
	
	# Create root subitems
	scenes_tree_root_item = tree.create_item(root_tree_item)
	objects_tree_root_item = tree.create_item(root_tree_item)
	
	# Set text for the tree items
	scenes_tree_root_item.set_text(0, "Scenes")
	objects_tree_root_item.set_text(0, "Objects")
	
	scenes_tree_root_item.add_button(0, add_icon_texture, 0)
	
	# Initialize children
	populate_scene_list()
	populate_objects_list()


# Populates the scene list
func populate_scene_list():
	# Remove all sub items
	var all_scenes_children: Array[TreeItem] = scenes_tree_root_item.get_children()
	
	for scene_item in all_scenes_children:
		scenes_tree_root_item.remove_child(scene_item)
	
	# Repopulate
	for scene in ProjectManager.scenes:
		var child_item: TreeItem = tree.create_item(scenes_tree_root_item)
		child_item.set_text(0, scene)
		
		child_item.add_button(0, edit_icon_texture, scene_tree_edit_button_index)
		child_item.add_button(0, delete_icon_texture, scene_tree_delete_button_index)


# Populates the object list
func populate_objects_list():
	# Remove all sub items
	var all_objects_children: Array[TreeItem] = objects_tree_root_item.get_children()
	
	for scene_item in all_objects_children:
		objects_tree_root_item.remove_child(scene_item)
	
	# Repopulate
	var object_index = 0
	for object in ProjectManager.objects:
		var child_item: TreeItem = tree.create_item(objects_tree_root_item)
		child_item.set_text(0, object)
		child_item.set_metadata(0, ProjectManager.objects_metadata[str(object_index)])
		object_index += 1


## Removes a specific scene in the tree
func remove_scene_at_index(scene_index: int):
	scenes_tree_root_item.remove_child(scenes_tree_root_item.get_child(scene_index))


## Renames a specific scene in the tree
func rename_scene_at_index(scene_index: int, new_name: String):
	scenes_tree_root_item.get_child(scene_index).set_text(0, new_name)


# Event handler for when a button is cliked on the tree
func _on_tree_button_clicked(item: TreeItem, column: int, id: int, mouse_button_index: int):
	if item == scenes_tree_root_item:
		if id == 0:
			emit_signal("create_scene_pressed")
	elif item.get_parent() == scenes_tree_root_item:
		var scene_index: int = item.get_index()
		var scene_name: String = item.get_text(0)
		
		match id:
			scene_tree_edit_button_index:
				emit_signal("scene_rename_request", scene_index, scene_name)
			scene_tree_delete_button_index:
				emit_signal("scene_delete_request", scene_index, scene_name)


# Item has been double clicked on the tree
func _on_tree_item_activated():
	var selected_item: TreeItem = tree.get_selected()
	var metadata = selected_item.get_metadata(0)
	
	# Make sure it is not the root item
	if selected_item != scenes_tree_root_item and selected_item != objects_tree_root_item:
		var selected_item_text: String = selected_item.get_text(0)
		if selected_item.get_parent() == scenes_tree_root_item:
			# Handle scene selected
			emit_signal("scene_selected", selected_item_text)
		elif selected_item.get_parent() == objects_tree_root_item:
			# Handle object selected
			emit_signal("object_selected", metadata)

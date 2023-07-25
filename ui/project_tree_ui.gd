extends Control

# Tree node reference
@onready var tree: Tree = $PanelContainer/VBoxContainer/MarginContainer/ScrollContainer/Tree

# Icons for tree items
@export var add_icon_texture: Texture2D
@export var delete_icon_texture: Texture2D

# Tree items references
var root_tree_item: TreeItem = null
var scenes_tree_root_item: TreeItem = null
var objects_tree_root_item: TreeItem = null


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
	populate_objects_list()
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


# Populates the object list
func populate_objects_list():
	# Remove all sub items
	var all_objects_children: Array[TreeItem] = objects_tree_root_item.get_children()
	
	for scene_item in all_objects_children:
		objects_tree_root_item.remove_child(scene_item)
	
	# Repopulate
	for object in ProjectManager.objects:
		var child_item: TreeItem = tree.create_item(objects_tree_root_item)
		child_item.set_text(0, object)


# Event handler for when a button is cliked on the tree
func _on_tree_button_clicked(item, column, id, mouse_button_index):
	if item == scenes_tree_root_item:
		if id == 0:
			# TODO: Add a new scene pressed
			pass


# Item has been double clicked on the tree
func _on_tree_item_activated():
	var selected_item: TreeItem = tree.get_selected()
	
	# Make sure it is not the root item
	if selected_item != scenes_tree_root_item and selected_item != objects_tree_root_item:
		var selected_item_text: String = selected_item.get_text(0)
		if selected_item.get_parent() == scenes_tree_root_item:
			# Handle scene selected
			pass
		elif selected_item.get_parent() == objects_tree_root_item:
			# Handle object selected
			pass

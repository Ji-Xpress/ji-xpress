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
	
	scenes_tree_root_item.add_button(0, add_icon_texture)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

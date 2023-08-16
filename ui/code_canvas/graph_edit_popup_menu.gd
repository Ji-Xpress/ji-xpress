extends PopupMenu

## Contains reference to the object index for metadata
@export var object_index: int = -1

## Custom entry points sub menu
var custom_entrypoint_submenu: PopupMenu = PopupMenu.new()
## Custom functions sub menu
var custom_function_submenu: PopupMenu = PopupMenu.new()
## Keeps track of the current pack entry points
var pack_entrypoints: Dictionary = {}
## An instance of the reference object for purposes of building metadata
var current_object_instance: Node2D = null

## Signal handler for when custom entrypoint item is selected
signal custom_entrypoint_item_selected(index: int)
## Signal handler for when custom function item is selected
signal custom_function_item_selected(index: int)
## Contains references to all function names
var code_function_names: Array[String] = []


# Called when the node enters the scene tree for the first time.
func _ready():
	var num_items: int = item_count
	var popup_menu_item_metdata: Array[Variant] = []
	var popup_menu_item_text: Array[String] = []
	var popup_menu_item_texture: Array[Texture2D] = []
	
	# Populate entry points from the active pack
	pack_entrypoints =  GameObjectsLoader.entry_points
	
	# Build submenus
	build_custom_entrypoints_submenu()
	
	# Set submenu names
	custom_entrypoint_submenu.set_name("custom_entrypoint_submenu")
	custom_function_submenu.set_name("custom_function_submenu")
	
	# Handle entrypoint item is selected
	custom_entrypoint_submenu.index_pressed.connect(on_entrypoint_menu_index_selected)
	# Handle function item is selected
	custom_function_submenu.index_pressed.connect(on_function_menu_index_selected)
	
	# Get item metadata
	for item in range(0, num_items):
		popup_menu_item_metdata.append(get_item_metadata(item))
		popup_menu_item_text.append(get_item_text(item))
		popup_menu_item_texture.append(get_item_icon(item))
	
	# Clear and rebuild
	clear()
	
	for item in range(0, num_items):
		if item == 3:
			# Custom Entry Point
			add_child(custom_entrypoint_submenu)
			add_submenu_item(popup_menu_item_text[item], "custom_entrypoint_submenu")
		elif item == 4:
			# Custom function
			add_child(custom_function_submenu)
			add_submenu_item(popup_menu_item_text[item], "custom_function_submenu")
		else:
			add_item(popup_menu_item_text[item])
			set_item_metadata(item, popup_menu_item_metdata[item])
			set_item_icon(item, popup_menu_item_texture[item])


# Event handler for when menu index is selected
func on_entrypoint_menu_index_selected(index: int):
	emit_signal("custom_entrypoint_item_selected", index)


# Event handler for when menu index is selected
func on_function_menu_index_selected(index: int):
	emit_signal("custom_function_item_selected", index)


## Builds custom entrypoints submenu
func build_custom_entrypoints_submenu():
	custom_entrypoint_submenu.clear()
	
	if pack_entrypoints.size() < 1:
		custom_entrypoint_submenu.add_item("No entrypoints detected")
		custom_entrypoint_submenu.set_item_disabled(0, true)
		
		return
	
	for entrypoint in pack_entrypoints:
		custom_entrypoint_submenu.add_item(entrypoint)


## Builds custom functions submenu
func build_custom_functions_submenu():
	custom_function_submenu.clear()
	code_function_names.clear()
	
	if current_object_instance != null:
		var metadata_node: ObjectCoder = current_object_instance.get_node(Constants.object_coder_node)
		
		if metadata_node != null:
			var all_functions = metadata_node.code_functions
			
			if all_functions.size() < 1:
				create_empty_function_submenu()
				return
			
			for function in all_functions:
				# Add item to menu and track it in the code_functions_names variable for same index
				custom_function_submenu.add_item(function.function_name)
				code_function_names.append(function.function_name)
		else:
			create_empty_function_submenu()
	else:
		create_empty_function_submenu()


## An empty functions submenu
func create_empty_function_submenu():
	custom_function_submenu.add_item("No functions detected")
	custom_function_submenu.set_item_disabled(0, true)

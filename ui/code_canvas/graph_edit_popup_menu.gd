extends PopupMenu

## Contains reference to the object index for metadata
@export var object_index: int = -1

## Custom entry points sub menu
var custom_entrypoint_submenu: PopupMenu = PopupMenu.new()
## Custom functions sub menu
var custom_function_submenu: PopupMenu = PopupMenu.new()

## Signal handler for when custom entrypoint item is selected
signal custom_entrypoint_item_selected(index: int)
## Signal handler for when custom function item is selected
signal custom_function_item_selected(index: int)


# Called when the node enters the scene tree for the first time.
func _ready():
	var num_items: int = item_count
	var popup_menu_item_metdata: Array[Variant] = []
	var popup_menu_item_text: Array[String] = []
	var popup_menu_item_texture: Array[Texture2D] = []
	
	# Build submenus
	build_custom_entrypoints_submenu()
	build_custom_functions_submenu()
	
	# Set submenu names
	custom_entrypoint_submenu.set_name("custom_entrypoint_submenu")
	custom_function_submenu.set_name("custom_function_submenu")
	
	# Handle entrypoint item is selected
	custom_entrypoint_submenu.index_pressed.connect(on_entrypoint_menu_index_selected)
	# Handle function item is selected
	custom_function_submenu.index_pressed.connect(on_function_menu_index_selected)
	
	# Get item metadata
	for item in range(0, num_items - 1):
		popup_menu_item_metdata.append(get_item_metadata(item))
		popup_menu_item_text.append(get_item_text(item))
		popup_menu_item_texture.append(get_item_icon(item))
	
	# Clear and rebuild
	clear()
	
	for item in range(0, num_items - 1):
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


func on_entrypoint_menu_index_selected(index: int):
	pass


func on_function_menu_index_selected(index: int):
	pass


## Builds custom entrypoints submenu
func build_custom_entrypoints_submenu():
	custom_entrypoint_submenu.clear()


## Builds custom functions submenu
func build_custom_functions_submenu():
	custom_function_submenu.clear()

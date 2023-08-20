extends Control


## Keeps track of the kind of tab page
enum TabType {
	TabScene, TabCode, TabNone
}

# Constants
const scene_prefix: String = "scn_"
const script_prefix: String = "scr_"
const canvas_ui: PackedScene = preload("res://ui/canvas_ui.tscn")
const script_ui: PackedScene = preload("res://ui/code_canvas_ui.tscn")
const prompt_flag_new_scene: String = "new_scene"

const prop_tab_tab_type: String = "tab_type"
const prop_tab_tab_name: String = "tab_name"

# Node references
@onready var tab_container: TabContainer = $PanelContainer/VBoxContainer/HSplitContainer/TabContainer
@onready var project_tree_ui: Control = $PanelContainer/VBoxContainer/HSplitContainer/ProjectTreeUI
@onready var dialogs: Control = $Dialogs
@onready var main_ui_dialogs: Control = $MainUIDialogs

@onready var save_project_button: Button = $PanelContainer/VBoxContainer/Menu/MarginContainer/HBoxContainer/SaveProjectButton
@onready var close_project_button: Button = $PanelContainer/VBoxContainer/Menu/MarginContainer/HBoxContainer/CloseProjectButton
@onready var run_project_scene_button: Button = $PanelContainer/VBoxContainer/Menu/MarginContainer/HBoxContainer/RunProjectSceneButton
@onready var run_project_button: Button = $PanelContainer/VBoxContainer/Menu/MarginContainer/HBoxContainer/RunProjectButton
@onready var project_settings_button: Button = $PanelContainer/VBoxContainer/Menu/MarginContainer/HBoxContainer/ProjectSettingsButton

@onready var tab_switch_timer: Timer = $PanelContainer/VBoxContainer/HSplitContainer/TabSwitchTimer

## Keeps track of current open tabs
var current_open_tabs: Dictionary = {}
## Keeps track of tab control requesting an action
var requesting_tab_instance_control: Control = null
## Keeps track of the curren tab type
var current_tab_type: TabType = TabType.TabNone
## Keeps track of the current scene name
var current_scene_name: String = ""
## Keeps track of the current script name
var current_script_name: String = ""
## Tab tracker dictionary
var tab_number_tracker: Dictionary = {}


## When a game object dialog is requested
func on_game_object_dialog_requested(node_instance: Control, request_position = null):
	requesting_tab_instance_control = node_instance
	main_ui_dialogs.add_game_object_dialog.requested_position = request_position
	main_ui_dialogs.show_game_object_dialog()


## Canvas settings popup requested
func on_canvas_settings_requested(node_instance: Control):
	requesting_tab_instance_control = node_instance
	main_ui_dialogs.show_canvas_settings_dialog()


## Close a canvas tab
func on_canvas_close_request(node_instance: Control, scene_id: String):
	node_instance.save_tab()
	node_instance.disconnect("tab_close_request", Callable(self, "on_canvas_close_request"))
	node_instance.queue_free()
	
	# What is the index of the removed tab?
	var removed_tab_index: int = current_open_tabs[scene_prefix + scene_id]
	remove_tab(removed_tab_index, scene_prefix + scene_id)


## Closes a script tab
func on_script_canvas_close_request(node_instance: Control, script_id: String):
	node_instance.save_tab()
	node_instance.disconnect("tab_close_request", Callable(self, "on_script_canvas_close_request"))
	node_instance.queue_free()
	
	# What is the index of the removed tab?
	var removed_tab_index: int = current_open_tabs[script_prefix + script_id]
	remove_tab(removed_tab_index, script_prefix + script_id)


## Removes a tab and decrements index
func remove_tab(removed_tab_index: int, id: String):
	# Lets iterate down the next set of open tab indexes
	current_open_tabs.erase(id)
	
	if tab_number_tracker.has(str(removed_tab_index)):
		tab_number_tracker.erase(str(removed_tab_index))
	
	# Handle situation where the tab is in the middle of others so that we can keep track
	for tab in current_open_tabs:
		if current_open_tabs[tab] >= removed_tab_index:
			# Re arrange the tab tracker
			if tab_number_tracker.has(str(current_open_tabs[tab])):
				tab_number_tracker[str(current_open_tabs[tab] - 1)] = tab_number_tracker[str(current_open_tabs[tab])]
				tab_number_tracker.erase(str(current_open_tabs[tab]))
			
			# Re-orient the current open tab index
			current_open_tabs[tab] -= 1


# Perform project save
func _on_save_project_button_pressed():
	for tab in tab_container.get_children():
		if tab.tab_common.is_invalidated:
			tab.save_tab()


# Perform project close
func _on_close_project_button_pressed():
	ProjectManager.clear_project_metadata()
	get_tree().change_scene_to_file("res://launcher.tscn")


# Project settings button clicked
func _on_project_settings_button_pressed():
	main_ui_dialogs.show_project_settings_dialog()


# We need to run the current scene
func _on_run_project_scene_button_pressed():
	if current_scene_name != "" and current_tab_type == TabType.TabScene:
		# Save the current tab if it needs saves
		var current_open_tab:int = tab_container.current_tab
		var current_child_tab_control: Control = tab_container.get_child(current_open_tab)
		
		if current_child_tab_control.tab_common.is_invalidated:
			current_child_tab_control.save_tab()
		
		main_ui_dialogs.show_canvas_player(current_scene_name)


# We need to run the project
func _on_run_project_button_pressed():
	# Save all changes
	_on_save_project_button_pressed()
	# Run the startup scene
	if ProjectManager.project_metadata[ProjectMetadata.prop_startup_scene] != "":
		main_ui_dialogs.show_canvas_player(ProjectManager.project_metadata[ProjectMetadata.prop_startup_scene])


# Create a new scene button has been pressed
func _on_project_tree_ui_create_scene_pressed():
	dialogs.show_input_prompt_dialog("Scene Name", "", prompt_flag_new_scene)


# An object has been selected from the tree
func _on_project_tree_ui_object_selected(object_metadata):
	var object_index: int = object_metadata[GameObjectsLoader.prop_object_index]
	var object_id: String = object_metadata[GameObjectsLoader.prop_object_id]
	var object_url: String = object_metadata[GameObjectsLoader.prop_object_url]
	var script_file_name = object_id + Constants.scripts_extension
	
	# Set the current tab type to Scene Type
	current_tab_type = TabType.TabCode
	
	# Open or create the relevant tab's content
	if not current_open_tabs.has(script_prefix + script_file_name):
		# New canvas scene instance
		var new_script_canvas: Control = script_ui.instantiate()
		# Track the scene name in the new control
		new_script_canvas.script_name = script_file_name
		new_script_canvas.is_new_file = not ProjectManager.script_file_exists(script_file_name)
		new_script_canvas.object_index = object_index
		# Add to the tab container
		tab_container.call_deferred("add_child", new_script_canvas)
		
		new_script_canvas.connect("tab_close_request", Callable(self, "on_script_canvas_close_request"))
		
		# Track the child control 
		await tab_container.child_entered_tree
		
		# Assign current tab to current file
		var tab_index: int = tab_container.get_child_count() - 1
		current_open_tabs[script_prefix + script_file_name] = tab_index
		
		# Open as current active tab and set tab title
		tab_switch_timer.start()
		await tab_switch_timer.timeout
		
		tab_container.current_tab = tab_index
		tab_container.set_tab_title(tab_index, script_file_name)
		
		# Track the tab
		tab_number_tracker[str(tab_index)] = {
			prop_tab_tab_type: TabType.TabCode,
			prop_tab_tab_name: script_file_name
		}
		
		current_script_name = script_file_name
	else:
		tab_container.current_tab = current_open_tabs[script_prefix + script_file_name]
	

# A scene has been selected from the tree
func _on_project_tree_ui_scene_selected(scene_name):
	# Set the current tab type to Scene Type
	current_tab_type = TabType.TabScene
	
	# Open or create the relevant tab's content
	if not current_open_tabs.has(scene_prefix + scene_name):
		# New canvas scene instance
		var new_canvas_scene: Control = canvas_ui.instantiate()
		# Track the scene name in the new control
		new_canvas_scene.scene_name = scene_name
		# Add to the tab container
		tab_container.call_deferred("add_child", new_canvas_scene)
		# Connect to game object dialog requested
		new_canvas_scene.connect("add_node_pressed", Callable(self, "on_game_object_dialog_requested"))
		new_canvas_scene.connect("canvas_settings_pressed", Callable(self, "on_canvas_settings_requested"))
		new_canvas_scene.connect("tab_close_request", Callable(self, "on_canvas_close_request"))
		
		# Track the child control 
		await tab_container.child_entered_tree
		
		# Assign current tab to current file
		var tab_index: int = tab_container.get_child_count() - 1
		current_open_tabs[scene_prefix + scene_name] = tab_index
		
		# Open as current active tab and set tab title
		tab_switch_timer.start()
		await tab_switch_timer.timeout
		
		tab_container.current_tab = tab_index
		tab_container.set_tab_title(tab_index, scene_name)
		
		# Track the tab
		tab_number_tracker[str(tab_index)] = {
			prop_tab_tab_type: TabType.TabScene,
			prop_tab_tab_name: scene_name
		}
		
		current_scene_name = scene_name
	else:
		tab_container.current_tab = current_open_tabs[scene_prefix + scene_name]


# Input prompt dialog result invoked
func _on_dialogs_input_prompt_result(result, flag):
	match flag:
		prompt_flag_new_scene:
			if ProjectManager.create_new_scene(result):
				project_tree_ui.populate_scene_list()


# Game object reference addition requested
func _on_main_ui_dialogs_game_object_window_result(game_object_reference, index, request_position):
	if requesting_tab_instance_control != null:
		requesting_tab_instance_control.add_game_object_url_to_canvas(game_object_reference, index, -1, null, request_position)


func _on_main_ui_dialogs_canvas_settings_window_result(settings):
	if requesting_tab_instance_control != null:
		requesting_tab_instance_control.apply_canvas_settings(settings)


# Set the current tab metadata
func _on_tab_container_tab_changed(tab):
	if tab_number_tracker.has(str(tab)):
		current_tab_type = tab_number_tracker[str(tab)][prop_tab_tab_type]
		if current_tab_type == TabType.TabScene:
			current_scene_name = tab_number_tracker[str(tab)][prop_tab_tab_name]
		else:
			current_scene_name = ""


# Display the documentation on a browser
func _on_help_button_pressed():
	OS.shell_open(Constants.documentation_link)


# Handle scene delete request
func _on_project_tree_ui_scene_delete_request(scene_index, scene_name):
	dialogs.show_confirmation_dialog("Are you sure you want to delete this scene?")
	await dialogs.confirmation_dialog_result
	
	if dialogs.confirmation_dialog_confirm_result:
		if ProjectManager.delete_scene(scene_name):
			project_tree_ui.remove_scene_at_index(scene_index)


# Handle scene rename request
func _on_project_tree_ui_scene_rename_request(scene_index, scene_name):
	pass

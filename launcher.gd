extends Control

enum FileDialogResult {
	Success, Cancelled, None
}

@onready var no_activity_label: Label = $PanelContainer/MarginContainer/VBoxContainer/ActivityList/NoRecentActivity
@onready var activity_list: ItemList = $PanelContainer/MarginContainer/VBoxContainer/ActivityList/ActivityList
@onready var dialogs: Control = $Dialogs
@onready var activity_list_double_click_timer: Timer = $PanelContainer/MarginContainer/VBoxContainer/ActivityList/ActivityListDoubleClickTimer

# Checks on the file dialog result status
var file_dialog_result: FileDialogResult = FileDialogResult.None
var current_selected_dir_name: String = ""
var current_selected_dir_path: String = ""

# Keeps track of all files
var all_current_files: Dictionary = {}

# When a file operation on the file dialog is completed
signal file_dialog_result_triggered


# Called when the node enters the scene tree for the first time.
func _ready():
	load_recent_projects()


# Reset status flags for file dialogs
func invalidate_file_dialog_result_flags():
	file_dialog_result = FileDialogResult.None
	current_selected_dir_name = ""
	current_selected_dir_path = ""


# Load recent projects
func load_recent_projects():
	if FileAccess.file_exists(Constants.recent_projects_file_name):
		var recent_projects_file = FileAccess.open(Constants.recent_projects_file_name, FileAccess.READ)
		
		if recent_projects_file == null:
			return false
		
		# Get the JSON and process it from the file
		var all_files: String = recent_projects_file.get_as_text()
		recent_projects_file.close()
		
		var all_files_dict = JSON.parse_string(all_files)
		
		if all_files_dict == null:
			return false
		
		# Assign to class variable
		all_current_files = all_files_dict
		
		var num_items: int = 0
		
		for current_file_key in all_current_files:
			var item = all_current_files[current_file_key]
			activity_list.add_item(item[RecentProjects.prop_path])
			num_items += 1
		
		# Do not show the no activity label if projects exist
		if num_items > 0:
			no_activity_label.visible = false
		
	return false


## Save the current recent projects dict to file
func save_recent_projects_to_file():
	var recent_projects_file = FileAccess.open(Constants.recent_projects_file_name, FileAccess.WRITE)
	
	if recent_projects_file == null:
		return false
	
	var all_files_str: String = JSON.stringify(all_current_files)
	recent_projects_file.store_string(all_files_str)
	
	recent_projects_file.close()


## Save recent project to current dictionary
func save_recent_project_to_dict(path: String):
	var metadata_entry: Dictionary = RecentProjects.generate_entry_metadata(path)
	
	if not all_current_files.has(metadata_entry[RecentProjects.prop_hash]):
		all_current_files[metadata_entry[RecentProjects.prop_hash]] = {
			RecentProjects.prop_path: path,
			RecentProjects.prop_time: metadata_entry[RecentProjects.prop_time]
		}
	else:
		all_current_files[metadata_entry[RecentProjects.prop_hash]][RecentProjects.prop_time] = metadata_entry[RecentProjects.prop_time]


# Item on the project List has been clicked
func _on_project_list_item_clicked(index, at_position, mouse_button_index):
	if not activity_list_double_click_timer.is_stopped():
		var path: String = activity_list.get_item_text(index)
		
		if ProjectManager.open_project(path):
			get_tree().change_scene_to_file("res://main_ui.tscn")
	else:
		activity_list_double_click_timer.start()


# Open External Project Button clicked
func _on_open_external_project_pressed():
	dialogs.set_file_open_dialog_mode_dir()
	dialogs.show_file_open_dialog()
	
	await file_dialog_result_triggered
	
	# Hide the dialog
	dialogs.hide_file_open_dialog()
	
	# Attempt to load the project
	if file_dialog_result == FileDialogResult.Success:
		if ProjectManager.open_project(current_selected_dir_path):
			save_recent_project_to_dict(current_selected_dir_path)
			save_recent_projects_to_file()
			get_tree().change_scene_to_file("res://main_ui.tscn")
		else:
			dialogs.show_accept_dialog("The folder does not contain a valid project")
	
	invalidate_file_dialog_result_flags()


# Create a new project
func _on_create_new_project_pressed():
	dialogs.set_file_open_dialog_mode_dir()
	dialogs.show_file_open_dialog()
	
	await file_dialog_result_triggered
	
	dialogs.hide_file_open_dialog()
	
	if file_dialog_result == FileDialogResult.Success:
		if ProjectManager.create_new_project(current_selected_dir_path):
			save_recent_project_to_dict(current_selected_dir_path)
			save_recent_projects_to_file()
			get_tree().change_scene_to_file("res://main_ui.tscn")
		else:
			dialogs.show_accept_dialog("There was a problem creating the project")
	
	invalidate_file_dialog_result_flags()


# Handle when the directory open dialog is invoked
func _on_dialogs_dir_opened(file_path: String, dir_name: String):
	current_selected_dir_name = dir_name
	current_selected_dir_path = file_path
	file_dialog_result = FileDialogResult.Success
	
	emit_signal("file_dialog_result_triggered")


# Handle when file or directory dialog is closed
func _on_dialogs_file_open_cancelled():
	file_dialog_result = FileDialogResult.Cancelled
	emit_signal("file_dialog_result_triggered")

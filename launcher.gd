extends Control

enum FileDialogResult {
	Success, Cancelled, None
}

@onready var no_activity_label: Label = $PanelContainer/MarginContainer/VBoxContainer/ActivityList/NoRecentActivity
@onready var activity_list: ItemList = $PanelContainer/MarginContainer/VBoxContainer/ActivityList/ActivityList
@onready var dialogs: Control = $Dialogs

# Checks on the file dialog result status
var file_dialog_result: FileDialogResult = FileDialogResult.None
var current_selected_dir_name: String = ""
var current_selected_dir_path: String = ""

signal file_dialog_result_triggered


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Item on the project List has been clicked
func _on_project_list_item_clicked(index, at_position, mouse_button_index):
	pass # Replace with function body.


# Reset status flags for file dialogs
func invalidate_file_dialog_result_flags():
	file_dialog_result = FileDialogResult.None
	current_selected_dir_name = ""
	current_selected_dir_path = ""


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

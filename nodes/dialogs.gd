extends Control

@onready var file_save_dialog: FileDialog = $FileSaveDialog
@onready var file_open_dialog: FileDialog = $FileOpenDialog
@onready var confirmation_dialog: ConfirmationDialog = $ConfirmationDialog
@onready var accept_dialog: AcceptDialog = $AcceptDialog

# Singal handling
signal file_opened(file_path: String, file_name: String)
signal dir_opened(file_path: String, dir_name: String)
signal file_saved(file_path: String, file_name: String)
signal dir_saved(file_path: String, dir_name: String)
signal file_open_cancelled
signal file_save_cancelled


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


## Shows the open dialog
func show_file_open_dialog():
	file_open_dialog.show()


## Hides the open dialog
func hide_file_open_dialog():
	file_open_dialog.hide()


## Shows the save dialog
func show_file_save_dialog():
	file_save_dialog.show()


## Hides the save dialog
func hide_file_save_dialog():
	file_save_dialog.hide()


## Shows the accept dialog with a message
func show_accept_dialog(message: String):
	accept_dialog.dialog_text = message
	accept_dialog.show()


## Hide the accept dialog with a message
func hide_accept_dialog():
	accept_dialog.dialog_text = ""
	accept_dialog.hide()


func set_file_open_dialog_mode_dir():
	file_open_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR


func set_file_open_dialog_mode_file():
	file_open_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE


# Signal handling
# When file is selcted from save file dialog
func _on_file_save_dialog_file_selected(path):
	emit_signal("file_saved", file_save_dialog.current_path, file_save_dialog.current_dir)


# When directory is selcted from save file dialog
func _on_file_save_dialog_dir_selected(dir):
	emit_signal("dir_saved", file_save_dialog.current_path, file_save_dialog.current_dir)


# When file is selcted from open file dialog
func _on_file_open_dialog_file_selected(path):
	emit_signal("file_opened", file_open_dialog.current_path, file_save_dialog.current_file)


# When folder is selcted from open file dialog
func _on_file_open_dialog_dir_selected(dir):
	emit_signal("dir_opened", file_open_dialog.current_path, file_save_dialog.current_dir)


# Confirmation dialog confirmed
func _on_confirmation_dialog_confirmed():
	pass # Replace with function body.


# Confirmation dialog cancelled
func _on_confirmation_dialog_canceled():
	pass # Replace with function body.


# Accept dialog confirmed
func _on_accept_dialog_confirmed():
	pass # Replace with function body.


# Accept dialog cancelled
func _on_accept_dialog_canceled():
	pass # Replace with function body.


# Cancel pressed
func _on_file_open_dialog_canceled():
	emit_signal("file_open_cancelled")


# Cancel pressed
func _on_file_save_dialog_canceled():
	emit_signal("file_save_cancelled")

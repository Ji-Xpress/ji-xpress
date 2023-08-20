extends Control

@onready var file_save_dialog: FileDialog = $FileSaveDialog
@onready var file_open_dialog: FileDialog = $FileOpenDialog
@onready var confirmation_dialog: ConfirmationDialog = $ConfirmationDialog
@onready var accept_dialog: AcceptDialog = $AcceptDialog
@onready var input_prompt_dialog: Window = $InputPromptDialog

# Singal handling
signal file_opened(file_path: String, file_name: String)
signal dir_opened(file_path: String, dir_name: String)
signal file_saved(file_path: String, file_name: String)
signal dir_saved(file_path: String, dir_name: String)
signal file_open_cancelled
signal file_save_cancelled
signal input_prompt_result(result: String, flag: String)
signal confirmation_dialog_result(result: bool)

## Stores the result of confirmation
var confirmation_dialog_confirm_result: bool = false


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


## Shows the confirm dialog
func show_confirmation_dialog(message: String):
	confirmation_dialog_confirm_result = false
	confirmation_dialog.dialog_text = message
	confirmation_dialog.show()


## Hides the confirm dialog
func hide_confirmation_dialog():
	confirmation_dialog.dialog_text = ""
	confirmation_dialog.hide()


## Shows the accept dialog with a message
func show_accept_dialog(message: String):
	accept_dialog.dialog_text = message
	accept_dialog.show()


## Hide the accept dialog with a message
func hide_accept_dialog():
	accept_dialog.dialog_text = ""
	accept_dialog.hide()


## Shows the input prompt dialog
func show_input_prompt_dialog(title: String, text: String, flag: String = "", is_identifer = true):
	input_prompt_dialog.text = text
	input_prompt_dialog.title = title
	input_prompt_dialog.flag = flag
	input_prompt_dialog.should_be_identifier = is_identifer
	input_prompt_dialog.show()


## Hides the input prompt dialog
func hide_input_prompt_dialog():
	accept_dialog.hide()


## Set the open dialog's operation mode to directory mode
func set_file_open_dialog_mode_dir():
	file_open_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR


## Set the open dialog's operation mode to file mode
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
	confirmation_dialog_confirm_result = true
	emit_signal("confirmation_dialog_result", true)


# Confirmation dialog cancelled
func _on_confirmation_dialog_canceled():
	confirmation_dialog_confirm_result = false
	emit_signal("confirmation_dialog_result", false)


# Accept dialog confirmed
func _on_accept_dialog_confirmed():
	pass


# Accept dialog cancelled
func _on_accept_dialog_canceled():
	pass


# Cancel pressed
func _on_file_open_dialog_canceled():
	emit_signal("file_open_cancelled")


# Cancel pressed
func _on_file_save_dialog_canceled():
	emit_signal("file_save_cancelled")


# Input prompt accepted
func _on_input_prompt_dialog_prompt_result(result, flag):
	emit_signal("input_prompt_result", result, flag)


# Input prompt cancelled
func _on_input_prompt_dialog_prompt_cancelled():
	pass # Replace with function body.

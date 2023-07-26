extends Control

# Node references
@onready var add_game_object_dialog: Window = $AddGameObjectDialog

# Signals
signal game_object_window_result(game_object_reference: String)


## Displays the game object dialog
func show_game_object_dialog():
	add_game_object_dialog.show()


# Add game object window result
func _on_add_game_object_dialog_window_result(game_object_reference):
	emit_signal("game_object_window_result", game_object_reference)

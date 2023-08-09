extends Control

# Node references
@onready var add_game_object_dialog: Window = $AddGameObjectDialog
@onready var canvas_settings_dialog: Window = $CanvasSettingsDialog
@onready var project_settings_dialog: Window = $ProjectSettingsDialog
@onready var canvas_player: Window = $CanvasPlayer

# Signals
signal game_object_window_result(game_object_reference: String, request_position)
signal canvas_settings_window_result(game_object_reference: String)


## Displays the game object dialog
func show_game_object_dialog():
	add_game_object_dialog.show()


## Displays the canvas settings
func show_canvas_settings_dialog():
	canvas_settings_dialog.show()


## Displays the project settings
func show_project_settings_dialog():
	project_settings_dialog.show()


## Shows the canvas player
func show_canvas_player(scene_name: String):
	canvas_player.scene_name = scene_name
	canvas_player.size = Vector2(ProjectManager.project_metadata[ProjectMetadata.prop_window_width], \
		ProjectManager.project_metadata[ProjectMetadata.prop_window_height])
	canvas_player.show()


# Add game object window result
func _on_add_game_object_dialog_window_result(game_object_reference, request_position):
	emit_signal("game_object_window_result", game_object_reference, request_position)


# Canvas settings window result
func _on_canvas_settings_window_window_result(results):
	emit_signal("canvas_settings_window_result", results)

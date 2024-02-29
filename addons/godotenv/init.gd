@tool
extends EditorPlugin

const AUTOLOAD_NAME: String = "GodotEnv"
const AUTOLOAD_PATH: String = "res://addons/godotenv/godotenv.gd"

func _enter_tree():
#	Used to automatically add GodotEnv as a autoload script when activated
	add_autoload_singleton(AUTOLOAD_NAME, AUTOLOAD_PATH)

func _exit_tree():
#	Remove when it's necessary anymore
	remove_autoload_singleton(AUTOLOAD_NAME)


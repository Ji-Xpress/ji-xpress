extends Node


## Get the app version setting
func get_app_version():
	return str(ProjectSettings.get_setting("application/config/app_version"))

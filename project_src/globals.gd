extends Node

# Current project manager
var project_manager: ProjectManager = ProjectManager.new()


## Get the app version setting
func get_app_version():
	return ProjectSettings.get_setting("application/config/app_version")

extends Object

## The path of the currently opened project
var current_project_path: String = ""


## Save project configuration
func save_project_configuration():
	if current_project_path != "":
		pass


## Creates a folder if it does not exist
func create_folder_if_not_exists(folder_name: String):
	if not DirAccess.dir_exists_absolute(folder_name):
		return DirAccess.make_dir_absolute(folder_name) == 0
	
	return false


## Creates a new project
func create_new_project(project_path: String):
	if DirAccess.dir_exists_absolute(project_path):
		if not FileAccess.file_exists(project_path + Constants.project_file_name):
			for directory in Constants.project_directories:
				if not create_folder_if_not_exists(project_path + directory):
					return false
		
		current_project_path = project_path


## Opens a currently existing project
func open_project():
	pass


## Saves a scene to the project folder
func save_scene():
	pass


## Opens a scene from the scenes folder
func open_scene():
	pass


## Saves a code instance to code folder
func save_code():
	pass


## Opens a code instance
func open_code():
	pass


## Performs a scan of the scenes folder and presents the scene names
func scan_scenes():
	pass


## Performs a scan of the code folder and presents all the code and metadata
func scan_code():
	pass

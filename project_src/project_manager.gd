extends Object

## The path of the currently opened project
var current_project_path: String = ""


## Creates a new project configuration
func create_project_configuration():
	Globals.project_metadata = ProjectMetadata.new()
	Globals.project_metadata.app_version = Globals.get_app_version()


## Save project configuration
func save_project_configuration():
	if current_project_path != "":
		
		var project_json: String = JSONUtils.class_to_json_string(Globals.project_metadata)
		save_file_to_folder(Constants.project_file_name, [], project_json)


## Creates a folder if it does not exist
func create_folder_if_not_exists(folder_name: String):
	if not DirAccess.dir_exists_absolute(folder_name):
		return DirAccess.make_dir_absolute(folder_name) == 0
	else:
		return true
	
	return false


## Saves file to folder
func save_file_to_folder(file_name: String, folder_name: Array[String], contents: String):
	if current_project_path != "":
		# Create folder it belongs to if it doesn't exist
		var relative_path: String = ""
		
		# Create folders from the folder array
		for folder in folder_name:
			if not create_folder_if_not_exists(folder):
				return false
			relative_path += folder + "/"
		
		# Open destination file
		var file: FileAccess = FileAccess.open(current_project_path + relative_path + file_name, FileAccess.WRITE)
		if file == null:
			return false
		
		file.store_string(contents)
		file.close()
		
		return true
	else:
		return false


## Creates a new project
func create_new_project(project_path: String):
	if DirAccess.dir_exists_absolute(project_path):
		if not FileAccess.file_exists(project_path + Constants.project_file_name):
			for directory in Constants.project_directories:
				if not create_folder_if_not_exists(project_path + directory):
					return false
		
		# Create a new project config set and save it
		create_project_configuration()
		save_project_configuration()
		
		# Set the current project path
		current_project_path = project_path
		
		return true
	
	return false


## Opens a currently existing project
func open_project(project_path: String):
	if DirAccess.dir_exists_absolute(project_path):
		var project_file_name: String = project_path + Constants.project_file_name
		if FileAccess.file_exists(project_file_name):
			var file: FileAccess = FileAccess.open(project_file_name, FileAccess.READ)
			
			if file == null:
				return false
			
			# Get file contents
			var project_metadata_str: String = file.get_as_text()
			var project_metadata: ProjectMetadata = JSONUtils.json_string_to_class(project_metadata_str, ProjectMetadata.new())
			Globals.project_metadata = project_metadata
			
			# Load all project objects
			current_project_path = project_path
			get_project_scenes()
			get_project_code()
			
			return true
	
	return false


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


## Get all scene instances
func get_project_scenes():
	pass


# Get all code instances
func get_project_code():
	pass

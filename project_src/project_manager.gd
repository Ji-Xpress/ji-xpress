extends Node

## The path of the currently opened project
var current_project_path: String = ""
## Current project metadata
var project_metadata: ProjectMetadata = null
## Collection of scenes in the current project
var scenes = []
## Collection of objects in the current project
var objects = []
## Collection of code files in the current project
var scripts = []


# When initializing
func _ready():
	clear_project_metadata()


## Clears project metadata
func clear_project_metadata():
	scenes = []
	objects = []
	scripts = []
	current_project_path = ""
	project_metadata = null


## Creates a new project configuration
func create_project_configuration():
	project_metadata = ProjectMetadata.new()
	project_metadata.app_version = Globals.get_app_version()


## Save project configuration
func save_project_configuration():
	if current_project_path != "":
		var project_json: String = JSONUtils.class_to_json_string(project_metadata)
		save_file_to_folder(current_project_path + Constants.project_file_name, true, [], project_json)


## Creates a folder if it does not exist
func create_folder_if_not_exists(folder_name: String):
	if not DirAccess.dir_exists_absolute(folder_name):
		return DirAccess.make_dir_absolute(folder_name) == 0
	else:
		return true
	
	return false


## Saves file to folder
func save_file_to_folder(file_name: String, is_absolute: bool, folder_name: Array[String], contents: String):
	if current_project_path != "" or is_absolute:
		# Create folder it belongs to if it doesn't exist
		var relative_path: String = ""
		
		# Create folders from the folder array
		if not is_absolute:
			for folder in folder_name:
				if not create_folder_if_not_exists(folder):
					return false
				relative_path += folder + "/"
		
		# Open destination file
		var file: FileAccess = null
		
		if is_absolute:
			FileAccess.open(file_name, FileAccess.WRITE)
		else:
			file = FileAccess.open(current_project_path + relative_path + file_name, FileAccess.WRITE)
		
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
		
		current_project_path = project_path
		
		# Create a new project config set and save it
		create_project_configuration()
		save_project_configuration()
		
		objects = get_project_objects()
		scenes = get_project_scenes()
		scripts = get_project_scripts()
		
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
			var metadata: ProjectMetadata = JSONUtils.json_string_to_class(project_metadata_str, ProjectMetadata.new())
			project_metadata = metadata
			
			# Load all project objects
			current_project_path = project_path
			
			objects = get_project_objects()
			scenes = get_project_scenes()
			scripts = get_project_scripts()
			
			return true
	return false


## Saves a scene to the project folder
func save_scene(file_name: String, scene_metadata: SceneMetaData):
	save_file_to_folder(file_name, false, [ Constants.project_scenes_dir ], JSONUtils.class_to_json_string(scene_metadata))


## Opens a scene from the scenes folder
func open_scene(file_name: String):
	if current_project_path != "":
		var scene_filename: String = current_project_path + Constants.project_scenes_dir + "/" + file_name
		if FileAccess.file_exists(scene_filename):
			var file: FileAccess = FileAccess.open(scene_filename, FileAccess.READ)
			
			if file == null:
				return false
			
			# Get file contents
			var scene_metadata_str: String = file.get_as_text()
			file.close()
			
			# Return results
			return JSONUtils.json_string_to_class(scene_metadata_str, SceneMetaData.new())
	else:
		return false


## Saves a script instance to code folder
func save_script(file_name: String, script_metadata: ScriptMetaData):
	save_file_to_folder(file_name, false, [ Constants.project_scripts_dir ], JSONUtils.class_to_json_string(script_metadata))


## Opens a script instance
func open_script(file_name: String):
	if current_project_path != "":
		var script_filename: String = current_project_path + Constants.project_scripts_dir + "\\" + file_name
		if FileAccess.file_exists(script_filename):
			var file: FileAccess = FileAccess.open(script_filename, FileAccess.READ)
			
			if file == null:
				return false
			
			# Get file contents
			var scene_metadata_str: String = file.get_as_text()
			file.close()
			
			# Return results
			return JSONUtils.json_string_to_class(scene_metadata_str, ScriptMetaData.new())
	else:
		return false


## Get all project objects
func get_project_objects():
	var extensions = get_dir_files("user://" + Constants.extensions_folder, ".pck")
	
	if extensions.size() > 0:
		# TODO: Object detection logic in PCK
		pass
	else:
		# TODO: Internal objects loading
		pass
	
	return []


## Get all scene instances
func get_project_scenes():
	return get_dir_files(current_project_path + Constants.project_scenes_dir, Constants.scene_extension)


## Get all code instances
func get_project_scripts():
	return get_dir_files(current_project_path + Constants.project_scripts_dir, Constants.scripts_extension)


## Get a list of files in the directory with specific extensions
func get_dir_files(path: String, extension: String):
	var file_array: Array[String] = []
	var dir = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if (not dir.current_is_dir()) and (file_name.get_extension() == extension):
				file_array.push_back(file_name)
			file_name = dir.get_next()
	
		return file_array
	else:
		return []

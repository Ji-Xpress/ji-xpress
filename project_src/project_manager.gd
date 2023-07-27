extends Node

## The path of the currently opened project
var current_project_path: String = ""
## Current project metadata
var project_metadata = null
## Collection of scenes in the current project
var scenes = []
## Holds metadata for all scenes
var scenes_metadata: Dictionary = {}
## Collection of objects in the current project
var objects = []
## Holds metadata for all objects
var objects_metadata: Dictionary = {}
## Collection of code files in the current project
var scripts = []
## Holds metadata for all script
var scripts_metadata: Dictionary = {}


# When initializing
func _ready():
	clear_project_metadata()


## Clears project metadata
func clear_project_metadata():
	scenes = []
	scenes_metadata = {}
	objects = []
	objects_metadata = {}
	scripts = []
	scripts_metadata = {}
	current_project_path = ""
	project_metadata = null


## Creates a new project configuration
func create_project_configuration(project_pack: String):
	project_metadata = ProjectMetadata.model_template()
	project_metadata[ProjectMetadata.prop_app_version] = Globals.get_app_version()
	project_metadata[ProjectMetadata.prop_project_pack] = project_pack


## Save project configuration
func save_project_configuration():
	if current_project_path != "":
		var project_json: String = JSON.stringify(project_metadata)
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
			file = FileAccess.open(file_name, FileAccess.WRITE)
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
func create_new_project(project_path: String, project_pack: String):
	if DirAccess.dir_exists_absolute(project_path):
		if not FileAccess.file_exists(project_path + Constants.project_file_name):
			for directory in Constants.project_directories:
				if not create_folder_if_not_exists(project_path + directory):
					return false
		
		current_project_path = project_path
		
		# Create a new project config set and save it
		create_project_configuration(project_pack)
		save_project_configuration()
		
		# Load the current set of objects
		GameObjectsLoader.load_internal_pack(project_pack)
		
		objects = get_project_objects()
		scenes = get_project_scenes()
		scripts = get_project_scripts()
		
		return true
	return false


## Creates a new scene
func create_new_scene(scene_name: String):
	var new_scene = SceneMetaData.model_template()
	
	new_scene[SceneMetaData.prop_app_version] = Globals.get_app_version()
	new_scene[SceneMetaData.prop_code_files] = []
	new_scene[SceneMetaData.prop_nodes] = {}
	
	if save_file_to_folder(scene_name + Constants.scene_extension, false, [ Constants.project_scenes_dir ], JSON.stringify(new_scene)):
		scenes.append(scene_name + Constants.scene_extension)
		scenes_metadata[scene_name + Constants.scene_extension] = new_scene
		return true


## Creates a new object in an existing scene
func create_new_scene_object(scene_name: String, node_id: String, object_id: String, object_position: Vector2, custom_properties: Dictionary):
	if not scenes_metadata.has(scene_name):
		return false
	
	var scene_instance = scenes_metadata[scene_name]
	
	if scene_instance[SceneMetaData.prop_nodes].has(object_id):
		return false
	
	# Create new object properties sets
	var new_object_properties: Dictionary = ObjectProperties.model_template()
	
	# Fill in the properties
	new_object_properties[ObjectProperties.prop_node_id] = node_id
	new_object_properties[ObjectProperties.prop_object_id] = object_id
	new_object_properties[ObjectProperties.prop_position] = object_position
	new_object_properties[ObjectProperties.prop_rotation] = 0
	new_object_properties[ObjectProperties.prop_custom_properties] = custom_properties
	new_object_properties[ObjectProperties.prop_code_files] = []
	
	scene_instance[SceneMetaData.prop_nodes][object_id] = new_object_properties
	
	return scene_instance[SceneMetaData.prop_nodes][object_id]


## Assigns a value to an object property
func assign_scene_object_property(scene_name: String, object_id: String, property: String, value):
	if not scenes_metadata.has(scene_name):
		return false
	
	if not scenes_metadata[scene_name][SceneMetaData.prop_nodes].has(object_id):
		return false
	
	if not scenes_metadata[scene_name][SceneMetaData.prop_nodes][object_id].has(property):
		return false
	
	scenes_metadata[scene_name][SceneMetaData.prop_nodes][object_id][property] = value
	
	return true


## Assigns a value to a custom object property
func assign_scene_object_custom_property(scene_name: String, object_id: String, property: String, value):
	if not scenes_metadata.has(scene_name):
		return false
	
	if not scenes_metadata[scene_name][SceneMetaData.prop_nodes].has(object_id):
		return false
	
	if not scenes_metadata[scene_name][SceneMetaData.prop_nodes][object_id][ObjectProperties.prop_custom_properties].has(property):
		return false
	
	scenes_metadata[scene_name][SceneMetaData.prop_nodes][object_id][ObjectProperties.prop_custom_properties][property] = value
	
	return true


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
			var metadata = JSON.parse_string(project_metadata_str)
			project_metadata = metadata
			
			# Load all project objects
			current_project_path = project_path
			
			# Load the current set of objects
			GameObjectsLoader.load_internal_pack(project_metadata[ProjectMetadata.prop_project_pack])
			
			objects = get_project_objects()
			scenes = get_project_scenes()
			scripts = get_project_scripts()
			
			return true
	return false


## Saves a scene to the project folder
func save_scene(file_name: String, scene_metadata: Dictionary):
	save_file_to_folder(file_name, false, [ Constants.project_scenes_dir ], JSON.stringify(scene_metadata))


## Opens a scene from the scenes folder
func open_scene(file_name: String, mute_results: bool = false):
	if current_project_path != "":
		var scene_filename: String = current_project_path + Constants.project_scenes_dir + "/" + file_name
		if FileAccess.file_exists(scene_filename):
			var file: FileAccess = FileAccess.open(scene_filename, FileAccess.READ)
			
			if file == null:
				return false
			
			# Get file contents
			var scene_metadata_str: String = file.get_as_text()
			file.close()
			
			var scene_dict: Dictionary = JSON.parse_string(scene_metadata_str)
			
			scenes_metadata[file_name] = scene_dict
			
			# Return results
			if mute_results:
				return true
			
			return scenes_metadata[file_name]
	else:
		return false


## Saves a script instance to code folder
func save_script(file_name: String, script_metadata: ScriptMetaData):
	save_file_to_folder(file_name, false, [ Constants.project_scripts_dir ], JSON.stringify(script_metadata))


## Opens a script instance
func open_script(file_name: String, mute_results: bool = false):
	if current_project_path != "":
		var script_filename: String = current_project_path + Constants.project_scripts_dir + "\\" + file_name
		if FileAccess.file_exists(script_filename):
			var file: FileAccess = FileAccess.open(script_filename, FileAccess.READ)
			
			if file == null:
				return false
			
			# Get file contents
			var scene_metadata_str: String = file.get_as_text()
			file.close()
			
			var script_dict = JSON.parse_string(scene_metadata_str)
			scripts_metadata[file_name] = script_dict
			
			# Return results
			if mute_results:
				return true
			
			return scripts_metadata[file_name]
	else:
		return false


## Get all project objects
func get_project_objects():
	var all_objects: Array[String] = []
	
	for object_type in GameObjectsLoader.game_objects:
		# Iterate through all game objects in the type
		var object_index: int = 0
		for game_object in GameObjectsLoader.game_objects[object_type]:
			var current_object: Dictionary = GameObjectsLoader.game_objects[object_type][game_object]
			all_objects.append(current_object[GameObjectsLoader.prop_description])
			objects_metadata[str(object_index)] = {
				GameObjectsLoader.prop_object_url: current_object[GameObjectsLoader.prop_object_url]
			}
			object_index += 1
	
	return all_objects


## Get all scene instances
func get_project_scenes():
	var all_scenes = get_dir_files(current_project_path + Constants.project_scenes_dir, Constants.scene_extension)
	
	# Build metadata
	for scene in all_scenes:
		open_scene(scene, true)
	
	return all_scenes


## Get all code instances
func get_project_scripts():
	var all_scripts = get_dir_files(current_project_path + Constants.project_scripts_dir, Constants.scripts_extension)
	
	# Build metadata
	for script in all_scripts:
		open_script(script, true)

	return all_scripts


## Get a list of files in the directory with specific extensions
func get_dir_files(path: String, extension: String):
	var file_array: Array[String] = []
	var dir = DirAccess.open(path)
	var sanitized_extension: String = extension.replace(".", "")
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if (not dir.current_is_dir()) and (file_name.get_extension() == sanitized_extension):
				file_array.push_back(file_name)
			file_name = dir.get_next()
	
		return file_array
	else:
		return []

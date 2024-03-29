extends Node

## Folder that stores scenes
const project_scenes_dir: String = "scenes"
## Folder that stores scripts
const project_scripts_dir: String = "scripts"
## Project config dir
const project_config_dir: String = "config"
## The project's file name, stored in the root folder
const project_file_name: String = "project.prj"
## Used to keep track of extensions
const extensions_folder: String = "extensions"
## Data store for recent projects
const recent_projects_file_name: String = "user://recent_projects.dat"
## Node name for object metadata node
const object_metadata_node: String = "ObjectMetaData"
## Node name for object functionality node
const object_functionality_node: String = "ObjectFunctionality"
## Node name for object coder node
const object_coder_node: String = "ObjectCoder"
## Node name for RectExtents node
const object_rectextents_node: String = "RectExtents2D"
## Link to the external documentation
const documentation_link: String = "https://github.com/Ji-Xpress/documentation/blob/main/README.md"
## Sets the drag node type
const drag_node_type: String = "drag_node_type"
## Sets the drag node data
const drag_node_data: String = "drag_node_data"
## Drag node type object
const drag_node_type_game_object: String = "drag_node_type_game_object"
## Env Setting or code environment
const code_environment_env: String = "code_environment"
## Visual Code Environment Setting
const code_environment_env_visual: String = "visual"
## Textual Code Environment Setting
const code_environment_env_code: String = "code"

# Collection of project directories
const project_directories: Array[String] = [
	project_scenes_dir,
	project_scripts_dir,
	project_config_dir
]

## Extenstion for scenes
const scene_extension = ".scn"
## Extenstion for scripts
const scripts_extension = ".scr"
## Extension for code files
const code_extension = ".cde"

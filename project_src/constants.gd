extends Object

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

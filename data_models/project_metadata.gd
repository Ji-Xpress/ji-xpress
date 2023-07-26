extends Object
class_name ProjectMetadata

# Constants
## App version
const prop_app_version: String = "app_version"
## Startup scene
const prop_startup_scene: String = "startup_scene"
## Pack attached to the project
const prop_project_pack: String = "project_pack"


## Return the dict template
static func model_template():
	return {
		prop_app_version: "",
		prop_startup_scene: "",
		prop_project_pack: ""
	}

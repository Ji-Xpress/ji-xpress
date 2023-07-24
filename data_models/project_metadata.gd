extends Object
class_name ProjectMetadata

# Constants
const prop_app_version: String = "app_version"
const prop_startup_scene: String = "startup_scene"


## Return the dict template
static func model_template():
	return {
		prop_app_version: "",
		prop_startup_scene: ""
	}

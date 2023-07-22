extends Object
class_name SceneMetaData

# Constants
const prop_app_version: String = "app_version"
const prop_code_files: String = "code_files"
const prop_nodes: String = "nodes"


## Return the dict template
static func model_template():
	return {
		prop_app_version: "",
		prop_code_files: [],
		prop_nodes: []
	}


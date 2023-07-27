extends Object
class_name SceneMetaData

# Constants
const prop_app_version: String = "app_version"
const prop_code_files: String = "code_files"
const prop_nodes: String = "nodes"
const prop_last_object_id: String = "prop_last_object_id"


## Return the dict template
static func model_template():
	return {
		prop_app_version: "",
		prop_code_files: [],
		prop_nodes: {},
		prop_last_object_id: -1
	}


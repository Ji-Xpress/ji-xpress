extends Object
class_name ObjectProperties

# Constants
const prop_node_id: String = "node_id"
const prop_object_id: String = "object_id"
const prop_rotation: String = "rotation"
const prop_position: String = "position"
const prop_code_files: String = "code_files"
const prop_custom_properties: String = "custom_properties"


## Return the dict template
static func model_template():
	return {
		prop_node_id: "",
		prop_object_id: "",
		prop_rotation: 0.0,
		prop_position: Vector2.ZERO,
		prop_code_files: [],
		prop_custom_properties: []
	}

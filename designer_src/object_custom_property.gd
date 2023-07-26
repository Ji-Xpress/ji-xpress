extends Resource
class_name ObjectCustomProperty

# Constants
const prop_prop_name: String = "prop_name"
const prop_prop_type: String = "prop_type"
const prop_prop_value: String = "prop_value"

@export var property_name: String = ""
@export var property_type: SharedEnums.PropertyType = SharedEnums.PropertyType.TypeString
@export var property_value: String = ""


## Return the dict template
static func model_template():
	return {
		prop_prop_name: "",
		prop_prop_type: SharedEnums.PropertyType.TypeString,
		prop_prop_value: "",
	}

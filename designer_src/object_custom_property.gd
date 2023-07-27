extends Resource
class_name ObjectCustomProperty

# Constants
const prop_prop_name: String = "property_name"
const prop_prop_type: String = "property_type"
const prop_prop_value: String = "property_value"
const prop_read_only: String = "property_read_only"

@export var property_name: String = ""
@export var property_type: SharedEnums.PropertyType = SharedEnums.PropertyType.TypeString
@export var property_value: String = ""
@export var property_read_only: bool = false


## Return the dict template
static func model_template():
	return {
		prop_prop_name: "",
		prop_prop_type: SharedEnums.PropertyType.TypeString,
		prop_prop_value: "",
		prop_read_only: false
	}

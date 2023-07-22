extends Object
class_name ObjectCustomProperty

# Constants
const prop_prop_name: String = "prop_name"
const prop_prop_type: String = "prop_type"
const prop_prop_value: String = "prop_value"


## Return the dict template
static func model_template():
	return {
		prop_prop_name: "",
		prop_prop_type: SharedEnums.PropertyType.TypeString,
		prop_prop_value: "",
	}

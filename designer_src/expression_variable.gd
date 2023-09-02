extends Resource
class_name ExpressionVariable

## Name of the variable
@export var variable_name: String = ""
## Variable type
@export var variable_type: SharedEnums.PropertyType = SharedEnums.PropertyType.TypeString
## Value of the variable
@export var variable_value: String = ""

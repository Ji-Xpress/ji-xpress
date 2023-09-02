extends Object
class_name ExpressionEngine

var game_object_instance: Node2D = null
var current_condition_type: String = ""

var additional_var_names: Array[String] = []
var additional_var_values = []


## Initializes the expression engine
func initialize_engine():
	# Add extra additional variables from object metadata
	for expression_var in game_object_instance.object_metadata.expression_variables:
		var name: String = expression_var.variable_name
		var type: SharedEnums.PropertyType = expression_var.variable_type
		var value: String = expression_var.variable_value
		
		match type:
			SharedEnums.PropertyType.TypeString:
				add_expression_variable(name, value)
			SharedEnums.PropertyType.TypeInt:
				add_expression_variable(name, int(value))
			SharedEnums.PropertyType.TypeFloat:
				add_expression_variable(name, float(value))
			SharedEnums.PropertyType.TypeDropDown:
				add_expression_variable(name, int(value))
			SharedEnums.PropertyType.TypeBool:
				add_expression_variable(name, value == "true")


## Adds an extra variable to the execution
func add_expression_variable(var_name: String, var_value):
	additional_var_names.append(var_name)
	additional_var_values.append(var_value)


## Evaluates an expression and sends back the results
func compute_expression(expression: String):
	var var_names: Array[String] = []
	var var_values = []
	
	# Build variable sets for the expression
	if current_condition_type != "":
		var condition_variable = SharedState.expression_variables.get(current_condition_type)
		if condition_variable != null:
			for variable in condition_variable:
				var_names.append(variable)
				var_values.append(SharedState.expression_variables[current_condition_type][variable])
	
	# Variables and properties
	# Game object variables
	var_names.append("variables")
	var_values.append(game_object_instance.object_coder.variable_values)
	# Global variables
	var_names.append("globals")
	var_values.append(SharedState.state_variables)
	# Game object properties
	var_names.append("properties")
	var_values.append(game_object_instance.object_metadata.prop_values)
	# Current scene
	var_names.append("current_scene")
	var_values.append(SharedState.current_scene)
	# Current object_id
	var_names.append("object_id")
	var_values.append(game_object_instance.object_metadata.object_id)
	
	# Object state variables
	# X axis position
	var_names.append("pos_x")
	var_values.append(game_object_instance.position.x)
	# Y axis position
	var_names.append("pos_y")
	var_values.append(game_object_instance.position.y)
	# Object rotation in degrees
	var_names.append("rotation")
	var_values.append(game_object_instance.rotation_degrees)
	
	# Add any additional variables
	for var_name in additional_var_names:
		var_names.append(var_name)
	
	for var_value in additional_var_values:
		var_values.append(var_value)
	
	# Evaluate expression and return results
	return evaluate(expression, var_names, var_values)


## Evaluation of an expression
func evaluate(command, variable_names = [], variable_values = []):
	var expression = Expression.new()
	var error = expression.parse(command, variable_names)
	if error != OK:
		push_error(expression.get_error_text())
		return null

	var result = expression.execute(variable_values, self)

	if not expression.has_execute_failed():
		return result
	else:
		return null

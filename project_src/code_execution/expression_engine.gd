extends Object
class_name ExpressionEngine

var game_object_instance: Node2D = null
var current_condition_type: String = ""


## Initializes the expression engine
func initialize_engine():
	pass


## Evaluates an expression and sends back the results
func compute_expression(expression: String):
	var var_names = []
	var var_values = []
	
	# Build variable sets for the expression
	if current_condition_type != "":
		if SharedState.has(current_condition_type):
			for variable in SharedState[current_condition_type]:
				var_names.append(variable)
				var_values.append(SharedState[current_condition_type][variable])
	
	var_names.append("variables")
	var_values.append(game_object_instance.object_coder.variable_values)
	var_names.append("globals")
	var_values.append(SharedState.state_variables)
	var_names.append("properties")
	var_values.append(game_object_instance.object_metadata.prop_values)
	
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

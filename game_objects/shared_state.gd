extends Node

var state_variables: Dictionary = {}
var expression_variables: Dictionary = {}
var current_scene: String = ""

signal broadcast(message_id: String, message)


## Clears variables in the shared state
func clear_state():
	state_variables = {}


## Initializes a set of variables
func initialize_variables(variables: Array[String]):
	for variable in variables:
		state_variables[variable] = null


## Gets the value of a variable
func get_variable(variable: String):
	if state_variables.has(variable):
		return state_variables[variable]
	
	return null


## Sets the value of a variable
func set_variable(variable: String, value):
	state_variables[variable] = value


## Perform a broadcast
func do_broadcast(message_id: String, message: String):
	emit_signal("broadcast", message_id, message)

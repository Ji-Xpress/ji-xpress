extends Node
class_name ObjectCodeNode

## Contains reference to the parent object
var object: Node2D = null


## Does a broadcast
func do_broadcast(message_id: String, message):
	SharedState.do_broadcast(message_id, message)


## Gets a parameter
func get_entry_param(entry_type: String, param_name: String, sub_param: String = ""):
	var entry_name: String = "entry_" + entry_type
	
	if not SharedState.expression_variables.has(entry_name):
		return null
	
	if not SharedState.expression_variables[entry_name].has(param_name):
		return null
	
	if sub_param != "":
		if not SharedState.expression_variables["entry_" + entry_type][param_name].has(sub_param):
			return null
		
		return SharedState.expression_variables["entry_" + entry_type][param_name][sub_param]
	else:
		return SharedState.expression_variables["entry_" + entry_type][param_name]


## Sets the property of the current object
func set_property(property: String, value):
	object.object_metadata.set_property(property, value)
	object.object_functionality.set_property(property, value)


## Sets the property of the current object
func get_property(property: String):
	object.object_metadata.get_property(property)

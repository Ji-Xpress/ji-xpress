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
	object.object_metadata.set_property(property, value, object.object_metadata.node_mode, object.object_metadata.node_mode)
	object.object_functionality.set_property(property, value, object.object_metadata.node_mode)


## Sets the property of the current object
func get_property(property: String):
	object.object_metadata.get_property(property)


## Sets the value of a global variable
func set_global_variable(variable: String, value):
	SharedState.set_variable(variable, value)


## Gets the value of a global variable
func get_global_variable(variable: String):
	return SharedState.get_variable(variable)


## Gets the position of the object
func get_object_position():
	return object.position


## Sets the position of the object
func set_object_position(position: Vector2, smoothing: bool = false, duration: float= 1.0):
	if smoothing:
		var tween: Tween = object.create_tween()
		tween.tween_property(object, "position", Vector2(position.x, position.y), duration)
		await tween.finished
	else:
		object.position = position


## Gets the rotation of the object in degrees
func get_object_rotation():
	return object.rotation_degrees


## Sets the position of the object
func set_object_rotation(degrees: float, smoothing: bool = false, duration: float= 1.0):
	if smoothing:
		var tween: Tween = object.create_tween()
		tween.tween_property(object, "rotation_degrees", degrees, duration)
		await tween.finished
	else:
		object.rotation_degrees = degrees


## Change the scene
func change_scene(scene_name: String):
	var message_payload = NodeToCanvasMessages.construct_scene_change_message(scene_name + Constants.scene_extension)
	object.object_functionality.send_message_to_canvas(message_payload)

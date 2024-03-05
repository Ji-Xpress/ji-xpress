extends Control

@onready var object_metadata: ObjectMetaData = $ObjectMetaData
@onready var object_functionality: ObjectFunctionality = $ObjectFunctionality
@onready var object_coder: ObjectCoder = $ObjectCoder
@onready var num_keys_count: Label = $KeysCounter/MarginContainer/NumCount
@onready var num_gems_count: Label = $GemCounter/MarginContainer/NumCount
@onready var keys_counter: HBoxContainer = $KeysCounter
@onready var gems_counter: HBoxContainer = $GemCounter

var update_code_execution_engine: CodeExecutionEngine = null

var key_count: int = 0
var gem_count: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	var keys_visible: bool = bool(object_metadata.get_property("keys_visible"))
	var gems_visible: bool = bool(object_metadata.get_property("gems_visible"))
	
	keys_counter.visible = keys_visible
	gems_counter.visible = gems_visible
	
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		update_code_execution_engine = object_coder.code_execution_engine()
		var code_execution_engine = object_coder.code_execution_engine()
		code_execution_engine.execute_from_entrypoint_type("ready")


func _process(delta):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		update_code_execution_engine.execute_from_entrypoint_type("update_loop")


## Sets the star count
func set_key_count(keys: int):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		key_count = keys
		num_keys_count.text = str(key_count)
		object_coder.set_variable("num_keys", key_count)


## Sets the star count
func set_gem_count(gems: int):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		gem_count = gems
		num_gems_count.text = str(gem_count)
		object_coder.set_variable("num_gems", gem_count)


## Sets the number of stars and updates the dispplay
func set_num_keys(parameters: Dictionary):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		set_key_count(int(parameters.keys))


## Sets the number of stars and updates the dispplay
func set_num_gems(parameters: Dictionary):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		set_gem_count(int(parameters.gems))


## Handle number of stars collected
func _on_object_coder_broadcast(message_id, message):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		if message_id == "increment_num_keys":
			var keys: int = int(message) + key_count
			set_key_count(keys)
		elif message_id == "increment_num_gems":
			var gems: int = int(message) + gem_count
			set_gem_count(gems)
	
	var code_execution_engine = object_coder.code_execution_engine()
	code_execution_engine.execute_from_entrypoint_type("broadcast")


func _on_object_functionality_property_changed(property, value, is_custom, run_mode):
	if property == "keys_visible":
		keys_counter.visible = bool(value)
	elif property == "gems_visible":
		gems_counter.visible = bool(value)

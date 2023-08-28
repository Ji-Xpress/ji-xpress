extends CharacterBody2D

@onready var object_metadata: ObjectMetaData = $ObjectMetaData
@onready var object_functionality: ObjectFunctionality = $ObjectFunctionality
@onready var object_coder: ObjectCoder = $ObjectCoder
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

# Property Parameters
var vertical_start_position: int = 1
var horizontal_start_position: int = 1
var vertical_distance: int = 0
var horizontal_distance: int = 0
var is_active: bool = true
var tween: Tween = null

# Update loop code execution
var update_code_execution_engine: CodeExecutionEngine = null

var initial_global_position: Vector2 = Vector2.ZERO

# Initialize
func _ready():
	tween = create_tween()
	
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		update_code_execution_engine = object_coder.code_execution_engine()
		var code_execution_engine = object_coder.code_execution_engine()
		code_execution_engine.execute_from_entrypoint_type("ready")
	else:
		collision_shape.disabled = true
	
	# Fill in property variables
	is_active = str(object_metadata.get_property("is_active")) == "true"
	vertical_start_position = int(object_metadata.get_property("vertical_start_position"))
	horizontal_start_position = int(object_metadata.get_property("horizontal_start_position"))
	vertical_distance = int(object_metadata.get_property("vertical_distance"))
	horizontal_distance = int(object_metadata.get_property("horizontal_distance"))
	
	# Set inital global position
	initial_global_position = global_position
	
	activate()
	do_tween()


## Callback for the tween
func tween_callback():
	pass


## Performs a tween
func do_tween():
	pass


# Activate / deactivate
func activate():
	pass


# Property has changed
func _on_object_functionality_property_changed(property, value, is_custom):
	match property:
		"is_active":
			pass
		"vertical_start_position":
			pass
		"horizontal_start_position":
			pass
		"vertical_distance":
			pass
		"horizontal_distance":
			pass


# Process the broadcast message
func _on_object_coder_broadcast(message_id, message):
	var code_execution_engine = object_coder.code_execution_engine()
	code_execution_engine.execute_from_entrypoint_type("broadcast")


# Update loop
func _process(delta):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		update_code_execution_engine.execute_from_entrypoint_type("update_loop")

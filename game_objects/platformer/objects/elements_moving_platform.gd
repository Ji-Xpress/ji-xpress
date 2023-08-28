extends CharacterBody2D

const position_top: int = 0
const position_bottom: int = 1
const position_left: int = 0
const position_right: int = 1

@onready var object_metadata: ObjectMetaData = $ObjectMetaData
@onready var object_functionality: ObjectFunctionality = $ObjectFunctionality
@onready var object_coder: ObjectCoder = $ObjectCoder
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

# Property Parameters
var vertical_start_position: int = 0
var horizontal_start_position: int = 0
var vertical_distance: int = 0
var horizontal_distance: int = 0
var is_active: bool = true
var move_horizontally: bool = true
var move_vertically: bool = false
var movement_duration: float = 1.0

var current_vertical_position: int = 0
var current_horizontal_position: int = 0

# Tween variavle
var tween: Tween = null
# Update loop code execution
var update_code_execution_engine: CodeExecutionEngine = null

var initial_global_position: Vector2 = Vector2.ZERO


# Initialize
func _ready():
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		update_code_execution_engine = object_coder.code_execution_engine()
		var code_execution_engine = object_coder.code_execution_engine()
		code_execution_engine.execute_from_entrypoint_type("ready")
		
		tween = create_tween()
	else:
		collision_shape.disabled = true
	
	# Fill in property variables
	fill_in_vars_from_props()
	
	# Set inital global position
	initial_global_position = global_position
	
	activate()
	do_tween()


## Fill in variables from props
func fill_in_vars_from_props():
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		# Fill in property variables
		is_active = str(object_metadata.get_property("is_active")) == "true"
		vertical_start_position = int(object_metadata.get_property("vertical_start_position"))
		horizontal_start_position = int(object_metadata.get_property("horizontal_start_position"))
		vertical_distance = int(object_metadata.get_property("vertical_distance"))
		horizontal_distance = int(object_metadata.get_property("horizontal_distance"))
		move_horizontally = str(object_metadata.get_property("move_horizontally")) == "true"
		move_vertically = str(object_metadata.get_property("move_vertically")) == "true"
		movement_duration = float(object_metadata.get_property("movement_duration"))


## Gets the movement vector based on settings
func calculate_movement_vector() -> Vector2:
	var new_position: Vector2 = global_position
	
	if move_horizontally:
		match current_horizontal_position:
			position_left:
				new_position.x += horizontal_distance
			position_right:
				new_position.x -= horizontal_distance
	
	if move_vertically:
		match current_vertical_position:
			position_top:
				new_position.y += vertical_distance
			position_bottom:
				new_position.y -= vertical_distance
	
	return new_position


## Callback for the tween
func tween_callback():
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		tween.stop()
		
		if current_horizontal_position == position_left:
			current_horizontal_position = position_right
		else:
			current_horizontal_position = position_left
		
		if current_vertical_position == position_top:
			current_vertical_position = position_bottom
		else:
			current_vertical_position = position_top
		
		var new_position: Vector2 = calculate_movement_vector()
		
		tween = create_tween()
		tween.tween_property(self, "global_position", new_position, movement_duration)
		tween.tween_callback(tween_callback)
		tween.play()


## Performs a tween
func do_tween():
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		if tween.is_running():
			tween.stop()
		
		global_position = initial_global_position
		var new_position: Vector2 = calculate_movement_vector()
		
		current_vertical_position = vertical_start_position
		current_horizontal_position = horizontal_start_position
		
		tween = create_tween()
		tween.tween_property(self, "global_position", new_position, movement_duration)
		tween.tween_callback(tween_callback)
		tween.play()
	


# Activate / deactivate
func activate():
	if is_active:
		sprite.modulate = Color(1, 1, 1, 1)
	else:
		sprite.modulate = Color(1, 1, 1, 0.5)
	
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		collision_shape.disabled = not is_active


# Property has changed
func _on_object_functionality_property_changed(property, value, is_custom):
	match property:
		"is_active":
			is_active = str(value) == "true"
			activate()
		"vertical_start_position":
			vertical_start_position = int(value)
			if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
				tween.stop()
				do_tween()
		"horizontal_start_position":
			horizontal_start_position = int(value)
			if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
				tween.stop()
				do_tween()
		"vertical_distance":
			vertical_distance = int(value)
			if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
				tween.stop()
				do_tween()
		"horizontal_distance":
			horizontal_distance = int(value)
			if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
				tween.stop()
				do_tween()


# Process the broadcast message
func _on_object_coder_broadcast(message_id, message):
	var code_execution_engine = object_coder.code_execution_engine()
	code_execution_engine.execute_from_entrypoint_type("broadcast")


# Update loop
func _process(delta):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		update_code_execution_engine.execute_from_entrypoint_type("update_loop")

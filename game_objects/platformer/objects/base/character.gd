extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var object_metadata: ObjectMetaData = $ObjectMetaData
@onready var object_functionality: ObjectFunctionality = $ObjectFunctionality
@onready var object_coder: ObjectCoder = $ObjectCoder
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sensor_collision_shape: CollisionShape2D  = $CollisionSensor/CollisionShape2D

var update_code_execution_engine: CodeExecutionEngine = null
var animated_sprite: AnimatedSprite2D = null
var camera: Camera2D = null

# Is current player?
var is_current: bool = true
var jump_force: int = JUMP_VELOCITY
var speed: int = SPEED

var is_dead: bool = false
var die_position: Vector2 = Vector2.ZERO


# Object initialization
func _ready():
	if has_node("AnimatedSprite2D"):
		animated_sprite = get_node("AnimatedSprite2D")
	
	if has_node("Camera2D"):
		camera = get_node("Camera2D")
	
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		update_code_execution_engine = object_coder.code_execution_engine()
		var code_execution_engine = object_coder.code_execution_engine()
		code_execution_engine.execute_from_entrypoint_type("ready")
		
		collision_shape.disabled = false
		sensor_collision_shape.disabled = false
		
		jump_force = int(object_metadata.get_property("jump_force"))
		speed = int(object_metadata.get_property("speed"))
	else:
		collision_shape.disabled = true
		sensor_collision_shape.disabled = true
	
	if object_metadata.get_property("is_current") == null:
		is_current = false
	else:
		is_current = str(object_metadata.get_property("is_current")) == "true"
	
	set_camera_enabled()


# Set camera is enabled or not
func set_camera_enabled():
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		if is_current and camera != null:
			camera.enabled = true
		elif not is_current and camera != null:
			camera.enabled = false


# Physics loop
func _physics_process(delta):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun and is_current:
		update_code_execution_engine.execute_from_entrypoint_type("update_loop")
		
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
			animated_sprite.animation = "jump"

		# Handle Jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = jump_force

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		
		if velocity.x > 0:
			if is_on_floor():
				animated_sprite.animation = "walk"
			animated_sprite.flip_h = false
		elif velocity.x < 0:
			if is_on_floor():
				animated_sprite.animation = "walk"
			animated_sprite.flip_h = true
		else:
			if is_on_floor():
				animated_sprite.animation = "idle"
		
		animated_sprite.play()

		move_and_slide()


# When a broadcast message is received
func _on_object_coder_broadcast(message_id, message):
	var code_execution_engine = object_coder.code_execution_engine()
	code_execution_engine.execute_from_entrypoint_type("broadcast")


# Area entered
func _on_collision_sensor_area_entered(area):
	var body_groups = area.get_groups()
	
	if body_groups.size() > 0:
		var body_group = body_groups[0]
		
		SharedState.expression_variables["entry_collides"]["body"] = {
			"type": body_group,
			"is_on_floor": is_on_floor()
		}
		
		var code_execution_engine = object_coder.code_execution_engine()
		code_execution_engine.execute_from_entrypoint_type("collides")


# Body entered
func _on_collision_sensor_body_entered(body):
	var body_groups = body.get_groups()
	
	if body_groups.size() > 0:
		var body_group = body_groups[0]
		
		SharedState.expression_variables["entry_collides"]["body"] = {
			"type": body_group,
			"is_on_floor": is_on_floor()
		}
		
		var code_execution_engine = object_coder.code_execution_engine()
		code_execution_engine.execute_from_entrypoint_type("collides")


func _on_object_functionality_property_changed(property, value, is_custom):
	if property == "is_current":
		is_current = bool(value)
		set_camera_enabled()


## Player dies
func die(params: Dictionary):
	camera.enabled = false
	
	# Set the canvas camera position
	var message_to_canvas_camera_position: Dictionary = {
		NodeToCanvasMessages.prop_node_to_canvas_message_message_id: NodeToCanvasMessages.node_to_canvas_set_camera_position,
		"position": position
	}
	var message_to_canvas_enable_camera: Dictionary = {
		NodeToCanvasMessages.prop_node_to_canvas_message_message_id: NodeToCanvasMessages.node_to_canvas_enable_camera,
		"enabled": true
	}
	
	object_functionality.send_message_to_canvas(message_to_canvas_camera_position)
	object_functionality.send_message_to_canvas(message_to_canvas_enable_camera)
	
	is_dead = true
	
	# Disable colliders
	collision_shape.set_deferred("disabled", true)
	sensor_collision_shape.set_deferred("disabled", true)
	
	die_position = global_position
	
	# Broadcast player death (manually)
	if not SharedState.expression_variables.has("entry_broadcast"):
		SharedState.expression_variables["entry_broadcast"] = {}
	
	SharedState.expression_variables["entry_broadcast"]["broadcast_message"] = {
		"message_id": "player_death",
		"message": ""
	}
	
	SharedState.do_broadcast("player_death", "")
	
	animated_sprite.animation = "jump"
	animated_sprite.play()
	
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", die_position + Vector2(0, -50), 0.5)
	tween.tween_callback(func():
		tween =  create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.tween_property(self, "global_position", die_position + Vector2(0, 1500), 5)
		tween.play()
		)
	tween.play()
	
	return true

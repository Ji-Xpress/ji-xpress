extends Area2D

@onready var object_metadata: ObjectMetaData = $ObjectMetaData
@onready var object_functionality: ObjectFunctionality = $ObjectFunctionality
@onready var object_coder: ObjectCoder = $ObjectCoder
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

var is_active: bool = true
var rotation_speed: float = 2.0
var tween: Tween = null
# Update loop code execution
var update_code_execution_engine: CodeExecutionEngine = null


# Called when the node enters the scene tree for the first time.
func _ready():
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		update_code_execution_engine = object_coder.code_execution_engine()
		var code_execution_engine = object_coder.code_execution_engine()
		code_execution_engine.execute_from_entrypoint_type("ready")
	else:
		collision_shape.disabled = true
	
	tween = create_tween()
	is_active = str(object_metadata.get_property("is_active")) == "true"
	set_rotation_speed(float(object_metadata.get_property("rotation_speed")))
	activate()


## Activates the gear
func activate():
	if is_active:
		sprite.modulate = Color(1, 1, 1, 1)
	else:
		sprite.modulate = Color(1, 1, 1, 0.5)
	
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		collision_shape.disabled = not is_active


## Tween callback
func rotate_tween_callback():
	tween.stop()
	sprite.rotation_degrees = 0
	
	tween = create_tween()
	var rotation_duration: float = float(60) / float(rotation_speed * 60)
	tween.tween_property(sprite, "rotation_degrees", 360, rotation_duration)
	tween.tween_callback(rotate_tween_callback)
	tween.play()


## Sets gear rotation speed
func set_rotation_speed(speed: float):
	rotation_speed = speed
	
	if tween.is_running():
		tween.stop()
	
	sprite.rotation_degrees = 0
	var rotation_duration: float = float(60) / float(rotation_speed * 60)
	tween = create_tween()
	tween.tween_property(sprite, "rotation_degrees", 360, rotation_duration)
	tween.tween_callback(rotate_tween_callback)
	tween.play()


# Value has changed
func _on_object_functionality_property_changed(property, value, is_custom):
	match property:
		"is_active":
			is_active = str(value) == "true"
			activate()
		"rotation_speed":
			set_rotation_speed(int(value))
			


# When an area enters
func _on_area_entered(area):
	SharedGameObjectLogic.common_collision_handler(area, object_coder)


# When a body enters
func _on_body_entered(body):
	SharedGameObjectLogic.common_collision_handler(body, object_coder)


# Update loop
func _process(delta):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		update_code_execution_engine.execute_from_entrypoint_type("update_loop")


# Process the broadcast message
func _on_object_coder_broadcast(message_id, message):
	var code_execution_engine = object_coder.code_execution_engine()
	code_execution_engine.execute_from_entrypoint_type("broadcast")


# Destroy the object
func destroy(params: Dictionary):
	queue_free()

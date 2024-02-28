extends Area2D

# Node references
@onready var object_metadata: ObjectMetaData = $ObjectMetaData
@onready var object_functionality: ObjectFunctionality = $ObjectFunctionality
@onready var object_coder: ObjectCoder = $ObjectCoder
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

var is_active: bool = true
# Update loop code execution
var update_code_execution_engine: CodeExecutionEngine = null
# Variables
var item_type: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	item_type = int(object_metadata.get_property("pickup_type"))
	change_sprite()
	
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		update_code_execution_engine = object_coder.code_execution_engine()
		var code_execution_engine = object_coder.code_execution_engine()
		code_execution_engine.execute_from_entrypoint_type("ready")
		
		collision_shape.set_deferred("disabled", false)
	else:
		collision_shape.set_deferred("disabled", true)
	
	is_active = str(object_metadata.get_property("is_active")) == "true"
	activate()


## Activates the pickup
func activate():
	SharedGameObjectLogic.common_activate(is_active, sprite, object_metadata, collision_shape)


## Change the sprite and load the correct sprite type by index
func change_sprite():
	sprite.texture = sprite.pickup_items[item_type]


# When a property changes
func _on_object_functionality_property_changed(property, value, is_custom):
	match property:
		"pickup_type":
			item_type = int(value)
			change_sprite()
		"is_active":
			is_active = str(value) == "true"
			activate()


# Area entered
func _on_area_entered(area):
	SharedGameObjectLogic.common_collision_handler(area, object_coder)


# Body entered
func _on_body_entered(body):
	SharedGameObjectLogic.common_collision_handler(body, object_coder)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		update_code_execution_engine.execute_from_entrypoint_type("update_loop")


# Broadcast handler
func _on_object_coder_broadcast(message_id, message):
	var code_execution_engine = object_coder.code_execution_engine()
	code_execution_engine.execute_from_entrypoint_type("broadcast")


# Destroy the object
func destroy(params: Dictionary = {}):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		queue_free()

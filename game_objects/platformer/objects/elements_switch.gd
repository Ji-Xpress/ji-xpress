extends Area2D

@onready var object_metadata: ObjectMetaData = $ObjectMetaData
@onready var object_functionality: ObjectFunctionality = $ObjectFunctionality
@onready var object_coder: ObjectCoder = $ObjectCoder
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

var item_color: int = 0
var is_pressed: bool = false
var is_active: bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
	item_color = int(object_metadata.get_property("color"))
	is_pressed = str(object_metadata.get_property("is_pressed")) == "true"
	change_sprite()
	
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		collision_shape.set_deferred("disabled", false)
	else:
		collision_shape.set_deferred("disabled", true)


## Change the sprite and load the correct sprite type by index
func change_sprite():
	var texture_var: Array[Texture2D] = []
	
	if is_pressed:
		texture_var = sprite.on_textures
	else:
		texture_var = sprite.off_textures
	
	sprite.texture = texture_var[item_color]


## Activates the key
func activate():
	SharedGameObjectLogic.common_activate(is_active, sprite, object_metadata, collision_shape)


# Body entered
func _on_body_entered(body):
	SharedGameObjectLogic.common_collision_handler(body, object_coder)


# Area entered
func _on_area_entered(area):
	SharedGameObjectLogic.common_collision_handler(area, object_coder)


# Process the broadcast message
func _on_object_coder_broadcast(message_id, message):
	var code_execution_engine = object_coder.code_execution_engine()
	code_execution_engine.execute_from_entrypoint_type("broadcast")


# Destroy the object
func destroy(params: Dictionary = {}):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		queue_free()


# When a property changes
func _on_object_functionality_property_changed(property, value, is_custom, run_mode):
	match property:
		"is_pressed":
			is_pressed = str(value) == "true"
			change_sprite()
		"is_active":
			is_active = str(value) == "true"
			activate()
		"color":
			item_color = int(value)
			change_sprite()


## Sets if pressed or not
func set_pressed(parameters: Dictionary):
	object_functionality.set_property("is_pressed", parameters.is_pressed)

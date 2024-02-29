extends StaticBody2D

const block_dimensions: Vector2 = Vector2(64, 64)

var platform_kind: PlatformerSingleton.platform_tile_kind
var bottom_sprite_exists: bool = false

var top_sprite: TileSpriteBase = null
var bottom_sprite: TileSpriteBase = null
var rect_extents: RectExtents2D = null
var current_width: int = block_dimensions.x
var current_height: int = block_dimensions.y

@onready var object_metadata: ObjectMetaData = $ObjectMetaData
@onready var object_functionality: ObjectFunctionality = $ObjectFunctionality
@onready var object_coder: ObjectCoder = $ObjectCoder
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var tile_sensor_collision_shape: CollisionShape2D = $TileSensor/CollisionShape2D

# Keeps track of whether it collides
@export var collides: bool = true

# Keeps track of if active or not
var is_active: bool = true
# Update loop code execution
var update_code_execution_engine: CodeExecutionEngine = null


# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize the object
	bottom_sprite_exists = has_node("BottomSprite")
	top_sprite = get_node("TopSprite")
	
	if bottom_sprite_exists:
		bottom_sprite = get_node("BottomSprite")
	
	rect_extents = get_node("RectExtents2D")
	
	# Disable collision shape when in run mode
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeDesign:
		collision_shape.set_deferred("disabled", true)
		tile_sensor_collision_shape.set_deferred("disabled", true)
	elif object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		collision_shape.set_deferred("disabled", not collides)
		tile_sensor_collision_shape.set_deferred("disabled", false)
		update_code_execution_engine = object_coder.code_execution_engine()
		var code_execution_engine = object_coder.code_execution_engine()
		code_execution_engine.execute_from_entrypoint_type("ready")
	
	# Load properties
	current_width = int(object_metadata.get_property("width")) * block_dimensions.x
	current_height = int(object_metadata.get_property("height")) * block_dimensions.y
	platform_kind = int(object_metadata.get_property("platform_kind"))
	is_active = str(object_metadata.get_property("is_active")) == "true"
	
	# Render
	set_platform_kind()
	invalidate_rect()
	activate_platform()


## Invalidate the rect
func invalidate_rect():
	# Prepare variables
	var width: int = current_width / block_dimensions.x
	var height: int = current_height / block_dimensions.y
	var extents_size: Vector2 = Vector2(current_width, current_height)
	
	# Set block parameters
	top_sprite.set_block_width(width)
	
	if bottom_sprite_exists:
		bottom_sprite.set_block_width(width)
	
	if bottom_sprite_exists:
		var bottom_height: int = height - 1
		if bottom_height > 0:
			bottom_sprite.visible = true
			bottom_sprite.set_block_height(bottom_height)
		else:
			bottom_sprite.visible = false
	else:
		top_sprite.set_block_height(height)
	
	# Reposition rect
	rect_extents.position.x = current_width / 2 - (block_dimensions.x / 2)
	rect_extents.position.y = current_height / 2 - (block_dimensions.y / 2)
	rect_extents.size = extents_size
	
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeDesign:
		# If in design mode change the size of the canvas hit area
		var canvas_mouse_hit_area: Area2D = get_node("CanvasMouseHitArea")
		
		if canvas_mouse_hit_area != null:
			canvas_mouse_hit_area.position.x = current_width / 2 - (block_dimensions.x / 2)
			canvas_mouse_hit_area.position.y = current_height / 2 - (block_dimensions.y / 2)
			canvas_mouse_hit_area.set_hit_size(extents_size, true)
	elif object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		# If in run mode change the size of the actual collider
		collision_shape.position.x = current_width / 2 - (block_dimensions.x / 2)
		collision_shape.position.y = current_height / 2 - (block_dimensions.y / 2)
		collision_shape.shape.size = extents_size
		
		tile_sensor_collision_shape.position.x = current_width / 2 - (block_dimensions.x / 2)
		tile_sensor_collision_shape.position.y = current_height / 2 - (block_dimensions.y / 2)
		tile_sensor_collision_shape.shape.size = extents_size


# When a property is changed
func _on_object_functionality_property_changed(property, value, is_custom, run_mode):
	if run_mode == object_metadata.node_mode:
		match property:
			"width":
				var width: int = int(value)
				current_width = width * block_dimensions.x
				invalidate_rect()
			"height":
				var height: int = int(value)
				current_height = height * block_dimensions.y
				invalidate_rect()
			"platform_kind":
				platform_kind = value
				set_platform_kind()
			"is_active":
				is_active = str(value) == "true"
				activate_platform()


## Sets the platform kind manually
func set_platform_kind():
	top_sprite.set_platform_kind(platform_kind)
	
	if bottom_sprite_exists:
		bottom_sprite.set_platform_kind(platform_kind)


## Activates or deactivates platform
func activate_platform():
	if collides:
		if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
			collision_shape.set_deferred("disabled", not is_active)
		
		if is_active:
			top_sprite.modulate = Color(1, 1, 1, 1)
			if bottom_sprite != null:
				bottom_sprite.modulate = Color(1, 1, 1, 1)
		else:
			top_sprite.modulate = Color(1, 1, 1, 0.5)
			if bottom_sprite != null:
				bottom_sprite.modulate = Color(1, 1, 1, 0.5)


# Area entered sensor
func _on_tile_sensor_area_entered(area):
	SharedGameObjectLogic.common_collision_handler(area, object_coder)


# Body entered sensor
func _on_tile_sensor_body_entered(body):
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
func destroy(params: Dictionary = {}):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		queue_free()

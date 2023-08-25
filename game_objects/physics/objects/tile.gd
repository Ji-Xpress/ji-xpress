extends StaticBody2D

# Dimensions of the sprite
const dimensions: Vector2 = Vector2(70, 70)

# Node references
@onready var object_metadata: ObjectMetaData = $ObjectMetaData
@onready var object_functionality: ObjectFunctionality = $ObjectFunctionality
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var object_coder: ObjectCoder = $ObjectCoder
@onready var sprite: Sprite2D = $Sprite2D
@onready var rect_extents: RectExtents2D = $RectExtents2D

var update_code_execution_engine: CodeExecutionEngine = null


# Called when the node enters the scene tree for the first time.
func _ready():
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeDesign:
		collision_shape.set_deferred("disabled", true)
	else:
		# Initiate the update loop executor
		update_code_execution_engine = object_coder.code_execution_engine()
		
		collision_shape.set_deferred("disabled", false)
		var code_execution_engine = object_coder.code_execution_engine()
		code_execution_engine.execute_from_entrypoint_type("ready")
	
	# Expand num blocks based on size
	var num_blocks: int = int(object_metadata.get_property("num_blocks"))
	set_num_blocks_for_tile(num_blocks)


## Sets the number of blocks for the tile (based on width)
func set_num_blocks_for_tile(value: int):
	var extents_size: Vector2 = Vector2(dimensions.x * int(value) + 6, 74)
	sprite.region_rect = Rect2(0, 0, dimensions.x * int(value), dimensions.y)
	rect_extents.size = extents_size
	
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeDesign:
		# If in design mode change the size of the canvas hit area
		var canvas_mouse_hit_area: Area2D = get_node("CanvasMouseHitArea")
		
		if canvas_mouse_hit_area != null:
			canvas_mouse_hit_area.set_hit_size(extents_size, true)
	elif object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		# If in run mode change the size of the actual collider
		collision_shape.shape.size = extents_size


# Handle when a property changes
func _on_object_functionality_property_changed(property, value, is_custom):
	if property == "num_blocks":
		set_num_blocks_for_tile(value)


# During the physics loop
func _physics_process(delta):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		update_code_execution_engine.execute_from_entrypoint_type("update_loop")

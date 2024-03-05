extends HBoxContainer

@onready var object_metadata: ObjectMetaData = $ObjectMetaData
@onready var object_functionality: ObjectFunctionality = $ObjectFunctionality
@onready var object_coder: ObjectCoder = $ObjectCoder
@onready var num_stars_count: Label = $MarginContainer/NumStarsCount

var update_code_execution_engine: CodeExecutionEngine = null

var num_stars: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		update_code_execution_engine = object_coder.code_execution_engine()
		var code_execution_engine = object_coder.code_execution_engine(true)
		code_execution_engine.execute_from_entrypoint_type("ready")


func _process(delta):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		update_code_execution_engine.execute_from_entrypoint_type("update_loop")


## Sets the star count
func set_star_count(stars: int):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		num_stars = stars
		num_stars_count.text = str(num_stars)
		object_coder.set_variable("num_stars", num_stars)


## Sets the number of stars and updates the dispplay
func set_num_stars(parameters: Dictionary):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		set_star_count(int(parameters.num_stars))


## Handle number of stars collected
func _on_object_coder_broadcast(message_id, message):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		if message_id == "increment_num_stars":
			var stars: int = int(message) + num_stars
			set_star_count(stars)
	
	var code_execution_engine = object_coder.code_execution_engine(true)
	code_execution_engine.execute_from_entrypoint_type("broadcast")

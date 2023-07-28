extends Area2D

# Node references
@onready var object_metadata: ObjectMetaData = $ObjectMetaData
@onready var object_functionality: ObjectFunctionality = $ObjectFunctionality
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var transition_timer: Timer = $TransitionTimer


# Called when the node enters the scene tree for the first time.
func _ready():
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeDesign:
		collision_shape.set_deferred("disabled", true)
	else:
		collision_shape.set_deferred("disabled", false)


# Signal that we need to change the scene
func signal_scene_change():
	var message_payload = NodeToCanvasMessages.construct_scene_change_message(object_metadata.get_property("destination_scene"))
	object_functionality.send_message_to_canvas(message_payload)


# Check to see if the alien has encountered the body
func _on_body_entered(body):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		if body.is_in_group("alien"):
			transition_timer.start()
			await transition_timer.timeout
			signal_scene_change()

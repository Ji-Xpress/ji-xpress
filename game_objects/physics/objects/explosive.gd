extends StaticBody2D

# Node references
@onready var object_metadata: ObjectMetaData = $ObjectMetaData
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeDesign:
		collision_shape.set_deferred("disabled", true)
	else:
		collision_shape.set_deferred("disabled", false)

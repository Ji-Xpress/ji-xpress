extends Control

const selectable_spite_node = preload("res://tests/selectable_sprite_node.tscn")

# Design Canvas
@onready var design_canvas: Node2D = $VBoxContainer/SubViewportContainer/SubViewport/DesignCanvas

var position_offset: Vector2 = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_add_sprite_node_pressed():
	var new_node: Node2D = selectable_spite_node.instantiate()
	new_node.position += position_offset
	position_offset += Vector2(20, 20)
	design_canvas.add_new_node(new_node)
	design_canvas.connect("node_selected", func(node): print("node selected"))

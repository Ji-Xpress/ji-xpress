@tool
extends Node2D

const Consts := preload("res://addons/rect_extents_2D/Consts.gd")

@export var color: Color = Consts.COLOR_DEFAULT:
	set = set_color

@export var size: Vector2 = Vector2(64, 64):
	set = set_size


var _rect : Rect2

#== node ==
func _ready() -> void:
	_recalculate_rect()
	queue_redraw()

func _draw() -> void:
	if not Engine.is_editor_hint:
		return
	draw_rect(_rect, color, false)


#== functions ==
func _recalculate_rect() -> void:
	_rect = Rect2(size / -2.0, size)


#== setters ==
func set_color(value : Color) -> void:
	color = value
	queue_redraw()


func set_size(value : Vector2) -> void:
	size = value
	_recalculate_rect()
	queue_redraw()

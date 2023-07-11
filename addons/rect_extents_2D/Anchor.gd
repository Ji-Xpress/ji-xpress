extends Object

const Consts := preload("res://addons/rect_extents_2D/Consts.gd")

var position : Vector2
var rect : Rect2


func _init(position : Vector2, size: Vector2 = Consts.ANCHOR_SIZE) -> void:
	self.position = position
	self.rect = Rect2(position - size / 2.0, size)


func draw(overlay: Control, color: Color = Consts.COLOR_DEFAULT) ->  void:
	overlay.draw_circle(position, Consts.CIRCLE_OUTER_RADIUS, color)
	overlay.draw_circle(position, Consts.CIRCLE_INNER_RADIUS, Consts.COLOR_WHITE)

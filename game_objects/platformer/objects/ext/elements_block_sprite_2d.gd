extends Sprite2D

@export var red_texture: Texture2D = null
@export var green_texture: Texture2D = null
@export var blue_texture: Texture2D = null

var textures: Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	textures = [ red_texture, green_texture, blue_texture ]

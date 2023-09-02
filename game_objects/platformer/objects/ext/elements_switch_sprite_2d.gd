extends Sprite2D

@export var blue_off_texture: Texture2D = null
@export var yellow_off_texture: Texture2D = null

@export var blue_on_texture: Texture2D = null
@export var yellow_on_texture: Texture2D = null

var on_textures: Array[Texture2D] = []
var off_textures: Array[Texture2D] = []


# Called when the node enters the scene tree for the first time.
func _ready():
	off_textures = [ blue_off_texture, yellow_off_texture ]
	on_textures = [ blue_on_texture, yellow_on_texture ]

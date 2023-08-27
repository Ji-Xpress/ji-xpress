extends TextureRect
class_name TileSpriteBase

## Block dimensions constant
const block_dimensions: Vector2 = Vector2(64, 64)

## Platform kind
@export var platform_tile_kind: PlatformerSingleton.platform_tile_kind = PlatformerSingleton.platform_tile_kind.sand
## Sand texture
@export var sand_texture: Texture2D
## Concrete texture
@export var concrete_texture: Texture2D

## Block width
var block_width: int = 1
## Block height
var block_height: int = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


## Sets the platform kind
func set_platform_kind(platform_kind: PlatformerSingleton.platform_tile_kind):
	match platform_kind:
		PlatformerSingleton.platform_tile_kind.sand:
			texture = sand_texture
		PlatformerSingleton.platform_tile_kind.concrete:
			texture = concrete_texture


## Invalidates texture
func invalidate_texture():
	size = Vector2(block_dimensions.x * block_width, block_dimensions.y * block_height)


## Sets the dimensions of the block
func set_block_dimensions(width: int, height: int):
	block_width = width
	block_height = height
	invalidate_texture()


## Sets the block width
func set_block_width(width: int):
	block_width = width
	invalidate_texture()


## Sets the block height
func set_block_height(height: int):
	block_height = height
	invalidate_texture()

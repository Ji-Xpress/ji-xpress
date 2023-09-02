extends Sprite2D

@export var book:Texture2D = null
@export var folder:Texture2D = null
@export var laptop:Texture2D = null
@export var coffee:Texture2D = null
@export var phone:Texture2D = null
@export var pen:Texture2D = null
@export var hammer:Texture2D = null
@export var saw:Texture2D = null
@export var hour_glass:Texture2D = null
@export var stearing_wheel:Texture2D = null
@export var boul:Texture2D = null
@export var knife:Texture2D = null
@export var cooking_pot:Texture2D = null
@export var frying_pan:Texture2D = null

## Pickup items
var pickup_items: Array = []


func _ready():
	pickup_items = [
		book, folder, laptop, coffee, phone, pen, hammer, saw, hour_glass, 
		stearing_wheel, boul, knife, cooking_pot, frying_pan
	]

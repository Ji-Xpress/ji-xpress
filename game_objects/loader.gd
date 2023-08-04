extends Node

# Description about what the pack is about
const prop_description: String = "description"
# Path in the PCK to initialize objects
const prop_loader: String = "loader"
# For external packs only
const prop_pack_url: String = "pack_url"
# Tracks the URL of a game object
const prop_object_url: String = "object_url"
# Tracks custom properties
const prop_custom_properties: String = "custom_properties"
# Used to play the pack
const prop_pack_player: String = "pack_player"
# For objects that will be in the foreground
const prop_foreground: String = "foreground"
# For objects that will be in the background
const prop_background: String = "background"
# For objects that will be a tile
const prop_tile: String = "tile"
# For shared state between the various scenes
const prop_shared_state: String = "shared_state"
# An index of internal resource packs
const internal_resource_packs: Dictionary = {
	"physics": {
		prop_description: "Physics Pack with Kenney Assets",
		prop_loader: "res://game_objects/physics/loader.gd",
		prop_pack_player: "res://game_objects/physics/player.tscn"
	}
}

## Keeps track of the current game pack
var current_game_pack: String = ""
## Keeps track of wether it is internal or not
var current_game_pack_internal: bool = true


# Keeping track of game objects
## Keeps track of external packs
var external_resource_packs: Dictionary = {}
## Game objects registered by initializing packs
var game_objects: Dictionary = {
	prop_foreground: {},
	prop_background: {},
	prop_tile: {},
	prop_shared_state: {}
}
## Shared variables between game objects
var shared_variables = {}


## Invalidates the game object cache
func reset_game_objects():
	game_objects = {
		prop_foreground: {},
		prop_background: {},
		prop_tile: {},
		prop_shared_state: {}
	}


## Load internal packs without the PCKs
func load_internal_pack(pack_name: String):
	if not internal_resource_packs.has(pack_name):
		return false
	
	var pack_data: Dictionary = internal_resource_packs[pack_name]
	var loader = load(pack_data[prop_loader])
	loader = loader.new()
	
	game_objects = loader.load_game_objects()
	shared_variables = loader.load_shared_variables()


## Load externally downloaded PCKs
func load_external_pck(pck_name: String):
	# TODO: Make use of the load_resource_pack function:
	# ProjectSettings.load_resource_pack("user://packs/pack.pck")
	# For more information: https://docs.godotengine.org/en/stable/tutorials/export/exporting_pcks.html
	pass

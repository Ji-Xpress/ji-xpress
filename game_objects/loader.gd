extends Node

# Description about what the pack is about
const description_prop: String = "description"
# Path in the PCK to initialize objects
const path_prop: String = "path"
# For external packs only
const path_pack_url: String = "pack_url"
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

const internal_resource_packs: Dictionary = {
	"physics": {
		description_prop: "Physics Pack with Kenney Assets",
		path_prop: "res://game_objects/physics/loader.gd",
		prop_pack_player: "res://game_objects/physics/player.tscn"
	}
}

# Keeping track of game objects
# Keeps track of external packs
var external_resource_packs: Dictionary = {}
# Game objects registered by initializing packs
var game_objects: Dictionary = {
	prop_foreground: {},
	prop_background: {},
	prop_tile: {},
	prop_shared_state: {}
}


## Load externally downloaded PCKs
func load_external_pcks():
	# TODO: Make use of the load_resource_pack function:
	# ProjectSettings.load_resource_pack("user://packs/pack.pck")
	# For more information: https://docs.godotengine.org/en/stable/tutorials/export/exporting_pcks.html
	pass


## Load internal packs without the PCKs
func load_internal_packs():
	pass

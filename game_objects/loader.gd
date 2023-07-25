extends Node

const description_prop: String = "description"
const path_prop: String = "path" 

const internal_resource_packs: Dictionary = {
	"physics": {
		description_prop: "Physics Pack with Kenney Assets",
		path_prop: "res://game_objects/physics/loader.gd"
	}
}

# Keeps track of external packs
var external_resource_packs: Dictionary = {}


## Load externally downloaded PCKs
func load_external_pcks():
	# TODO: Make use of the load_resource_pack function:
	# ProjectSettings.load_resource_pack("user://packs/pack.pck")
	# For more information: https://docs.godotengine.org/en/stable/tutorials/export/exporting_pcks.html
	pass


## Load internal packs without the PCKs
func load_internal_packs():
	pass

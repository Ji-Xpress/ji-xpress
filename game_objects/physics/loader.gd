extends Node


## Load all Game Object instances and metadata
func load_game_objects():
	return {
		GameObjectsLoader.prop_foreground: {
			"alien": {
				GameObjectsLoader.prop_description: "Alien Character",
				GameObjectsLoader.prop_object_url: "res://game_objects/physics/objects/alien.tscn",
				GameObjectsLoader.prop_custom_properties: {}
			}
		},
		GameObjectsLoader.prop_background: {},
		GameObjectsLoader.prop_tile: {},
		GameObjectsLoader.prop_shared_state: {}
	}

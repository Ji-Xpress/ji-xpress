extends Node


## Load all Game Object instances and metadata
func load_game_objects():
	return {
		GameObjectsLoader.prop_foreground: {
			"alien": {
				GameObjectsLoader.prop_description: "Alien Character",
				GameObjectsLoader.prop_object_url: "res://game_objects/physics/objects/alien.tscn",
			},
			"coin": {
				GameObjectsLoader.prop_description: "Coin",
				GameObjectsLoader.prop_object_url: "res://game_objects/physics/objects/coin.tscn",
			},
			"explosive": {
				GameObjectsLoader.prop_description: "Explosive",
				GameObjectsLoader.prop_object_url: "res://game_objects/physics/objects/explosive.tscn",
			},
			"large_block": {
				GameObjectsLoader.prop_description: "Large Block",
				GameObjectsLoader.prop_object_url: "res://game_objects/physics/objects/big_block.tscn",
			},
			"small_block": {
				GameObjectsLoader.prop_description: "Small Block",
				GameObjectsLoader.prop_object_url: "res://game_objects/physics/objects/small_block.tscn",
			},
			"star": {
				GameObjectsLoader.prop_description: "Star",
				GameObjectsLoader.prop_object_url: "res://game_objects/physics/objects/star.tscn",
			}
		},
		GameObjectsLoader.prop_background: {
			"desert_background": {
				GameObjectsLoader.prop_description: "Desert Background",
				GameObjectsLoader.prop_object_url: "res://game_objects/physics/objects/background.tscn",
			}
		},
		GameObjectsLoader.prop_tile: {
			"tile": {
				GameObjectsLoader.prop_description: "Tile",
				GameObjectsLoader.prop_object_url: "res://game_objects/physics/objects/tile.tscn",
			}
		},
		GameObjectsLoader.prop_shared_state: {}
	}

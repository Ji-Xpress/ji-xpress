extends PackLoaderBase


## Load all Game Object instances and metadata
func load_game_objects():
	return {
		GameObjectsLoader.prop_foreground: {
			"alien": {
				GameObjectsLoader.prop_description: "Alien Character [Main Character]",
				GameObjectsLoader.prop_object_url: "res://game_objects/physics/objects/alien.tscn",
			},
			"coin": {
				GameObjectsLoader.prop_description: "Coin [Scene Element]",
				GameObjectsLoader.prop_object_url: "res://game_objects/physics/objects/coin.tscn",
			},
			"destination": {
				GameObjectsLoader.prop_description: "Destination [Scene Element]",
				GameObjectsLoader.prop_object_url: "res://game_objects/physics/objects/destination.tscn",
			},
			"explosive": {
				GameObjectsLoader.prop_description: "Explosive [Scene Element]",
				GameObjectsLoader.prop_object_url: "res://game_objects/physics/objects/explosive.tscn",
			},
			"large_block": {
				GameObjectsLoader.prop_description: "Large Block [Scene Element]",
				GameObjectsLoader.prop_object_url: "res://game_objects/physics/objects/big_block.tscn",
			},
			"small_block": {
				GameObjectsLoader.prop_description: "Small Block [Scene Element]",
				GameObjectsLoader.prop_object_url: "res://game_objects/physics/objects/small_block.tscn",
			},
			"star": {
				GameObjectsLoader.prop_description: "Star [Scene Element]",
				GameObjectsLoader.prop_object_url: "res://game_objects/physics/objects/star.tscn",
			}
		},
		GameObjectsLoader.prop_background: {
			"background_colored_desert": {
				GameObjectsLoader.prop_description: "Colored Desert [Background]",
				GameObjectsLoader.prop_object_url: "res://game_objects/shared/backgrounds/colored_desert.tscn",
			},
			"background_colored_forest": {
				GameObjectsLoader.prop_description: "Colored Forest [Background]",
				GameObjectsLoader.prop_object_url: "res://game_objects/shared/backgrounds/colored_forest.tscn",
			},
			"background_colored_trees": {
				GameObjectsLoader.prop_description: "Colored Tree [Background]",
				GameObjectsLoader.prop_object_url: "res://game_objects/shared/backgrounds/colored_trees.tscn",
			},
			"background_colored_tall_trees": {
				GameObjectsLoader.prop_description: "Colored Tall Trees [Background]",
				GameObjectsLoader.prop_object_url: "res://game_objects/shared/backgrounds/colored_tall_trees.tscn",
			},
			"desert_background": {
				GameObjectsLoader.prop_description: "Desert Background [Background]",
				GameObjectsLoader.prop_object_url: "res://game_objects/shared/backgrounds/desert_background.tscn",
			},
		},
		GameObjectsLoader.prop_tile: {
			"tile": {
				GameObjectsLoader.prop_description: "Tile",
				GameObjectsLoader.prop_object_url: "res://game_objects/physics/objects/tile.tscn",
			}
		},
		GameObjectsLoader.prop_user_interface: {
			"star_counter": {
				GameObjectsLoader.prop_description: "Star Counter [User Interface]",
				GameObjectsLoader.prop_object_url: "res://game_objects/physics/objects/star_counter.tscn",
			}
		}
	}


## Load all shared variables
func load_shared_variables():
	# Entry shared state variables
	SharedState.expression_variables["entry_collides"] = {}
	SharedState.expression_variables["entry_broadcast"] = {}
	
	# Shared variables metadata
	return {
		"shared_var_sample": {
			GameObjectsLoader.prop_description: "Sample Variable",
			GameObjectsLoader.prop_value: 0
		}
	}


## Entry points for the visual coding environment
func load_code_entry_points():
	return {
		"ready" : {
			GameObjectsLoader.prop_description: "When an object is ready"
		},
		"collides": {
			GameObjectsLoader.prop_description: "When an object collides"
		},
		"update_loop": {
			GameObjectsLoader.prop_description: "During the update loop"
		},
		"broadcast": {
			GameObjectsLoader.prop_description: "When the broadcast is done"
		}
	}

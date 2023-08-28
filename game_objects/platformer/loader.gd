extends PackLoaderBase


## Load all Game Object instances and metadata
func load_game_objects():
	return {
		GameObjectsLoader.prop_foreground: {
			"character_game_console": {
				GameObjectsLoader.prop_description: "Character: Game Console",
				GameObjectsLoader.prop_object_url: "res://game_objects/platformer/objects/character_game_console.tscn",
			},
			"elements_switch": {
				GameObjectsLoader.prop_description: "Elements: Switch",
				GameObjectsLoader.prop_object_url: "res://game_objects/platformer/objects/elements_switch.tscn",
			},
			"elements_door_open": {
				GameObjectsLoader.prop_description: "Elements: Open Door",
				GameObjectsLoader.prop_object_url: "res://game_objects/platformer/objects/elements_door_open.tscn",
			},
			"elements_door_locked": {
				GameObjectsLoader.prop_description: "Elements: Locked Door",
				GameObjectsLoader.prop_object_url: "res://game_objects/platformer/objects/elements_door_locked.tscn",
			},
			"elements_block": {
				GameObjectsLoader.prop_description: "Elements: Block",
				GameObjectsLoader.prop_object_url: "res://game_objects/platformer/objects/elements_block.tscn",
			},
			"elements_moving_platform": {
				GameObjectsLoader.prop_description: "Elements: Moving Platform",
				GameObjectsLoader.prop_object_url: "res://game_objects/platformer/objects/elements_moving_platform.tscn",
			},
			"elements_portal": {
				GameObjectsLoader.prop_description: "Elements: Portal",
				GameObjectsLoader.prop_object_url: "res://game_objects/platformer/objects/elements_moving_portal.tscn",
			},
			"items_key": {
				GameObjectsLoader.prop_description: "Items: Key",
				GameObjectsLoader.prop_object_url: "res://game_objects/platformer/objects/items_key.tscn",
			},
			"items_gem": {
				GameObjectsLoader.prop_description: "Items: Key",
				GameObjectsLoader.prop_object_url: "res://game_objects/platformer/objects/items_gem.tscn",
			},
			"items_heart": {
				GameObjectsLoader.prop_description: "Items: Key",
				GameObjectsLoader.prop_object_url: "res://game_objects/platformer/objects/items_heart.tscn",
			},
			"hazard_saw": {
				GameObjectsLoader.prop_description: "Hazard: Saw",
				GameObjectsLoader.prop_object_url: "res://game_objects/platformer/objects/hazard_saw.tscn",
			},
		},
		GameObjectsLoader.prop_background: {
			"background_colored_desert": {
				GameObjectsLoader.prop_description: "Background: Colored Desert",
				GameObjectsLoader.prop_object_url: "res://game_objects/shared/backgrounds/colored_desert.tscn",
			},
			"background_colored_forest": {
				GameObjectsLoader.prop_description: "Background: Colored Forest",
				GameObjectsLoader.prop_object_url: "res://game_objects/shared/backgrounds/colored_forest.tscn",
			},
			"background_colored_trees": {
				GameObjectsLoader.prop_description: "Background: Colored Tree",
				GameObjectsLoader.prop_object_url: "res://game_objects/shared/backgrounds/colored_trees.tscn",
			},
			"background_colored_tall_trees": {
				GameObjectsLoader.prop_description: "Background: Colored Tall Trees",
				GameObjectsLoader.prop_object_url: "res://game_objects/shared/backgrounds/colored_tall_trees.tscn",
			},
			"background_desert_background": {
				GameObjectsLoader.prop_description: "Background: Desert Background",
				GameObjectsLoader.prop_object_url: "res://game_objects/shared/backgrounds/desert_background.tscn",
			},
		},
		GameObjectsLoader.prop_tile: {
			"tiles_grass": {
				GameObjectsLoader.prop_description: "Tiles: Grass",
				GameObjectsLoader.prop_object_url: "res://game_objects/platformer/objects/tiles_grass.tscn",
			},
			"tiles_sand": {
				GameObjectsLoader.prop_description: "Tiles: Sand",
				GameObjectsLoader.prop_object_url: "res://game_objects/platformer/objects/tiles_sand.tscn",
			},
			"tiles_ice": {
				GameObjectsLoader.prop_description: "Tiles: Ice",
				GameObjectsLoader.prop_object_url: "res://game_objects/platformer/objects/tiles_ice.tscn",
			},
			"tiles_bricks": {
				GameObjectsLoader.prop_description: "Tiles: Bricks",
				GameObjectsLoader.prop_object_url: "res://game_objects/platformer/objects/tiles_bricks.tscn",
			},
			"tiles_placeholder": {
				GameObjectsLoader.prop_description: "Tiles: Placeholder",
				GameObjectsLoader.prop_object_url: "res://game_objects/platformer/objects/tiles_placeholder.tscn",
			},
			"hazard_thorns": {
				GameObjectsLoader.prop_description: "Hazard: Thorns",
				GameObjectsLoader.prop_object_url: "res://game_objects/platformer/objects/hazard_thorns.tscn",
			},
		},
		GameObjectsLoader.prop_user_interface: {
			"top_bar": {
				GameObjectsLoader.prop_description: "User Interface: Top bar",
				GameObjectsLoader.prop_object_url: "res://game_objects/platformer/objects/top_bar.tscn",
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

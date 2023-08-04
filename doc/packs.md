### Pack Object Loading Process

The meat of the loader is in the `GameObjectLoader` singleton (`res://game_objects/loader.gd`)

This is how it works:

* It loads the game object index for the pack.
* Loads shared variables for the pack.

```gdscript
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

## Load internal packs without the PCKs
func load_internal_pack(pack_name: String):
    if not internal_resource_packs.has(pack_name):
        return false

    var pack_data: Dictionary = internal_resource_packs[pack_name]
    var loader = load(pack_data[prop_loader])
    loader = loader.new()

    game_objects = loader.load_game_objects()
    shared_variables = loader.load_shared_variables()
```

* The `ProjectManager` singleton indexes the various game objects in the Game Pack.
* This is instantiated during the process of opening up a project using `ProjectManager` singleton (`res://project_src/project_manager.gd`):

```gdscript
## Holds metadata for all objects
var objects_metadata: Dictionary = {}

## Opens a currently existing project
func open_project(project_path: String):
    # Code to load project from a file in the path..

    var project_metadata_str: String = file.get_as_text()
    var metadata = JSON.parse_string(project_metadata_str)
    project_metadata = metadata

    # Load the current set of objects. Note: ATM we use internal packs only
    GameObjectsLoader.load_internal_pack(project_metadata[ProjectMetadata.prop_project_pack])

    objects = get_project_objects()
    scenes = get_project_scenes()
    scripts = get_project_scripts()


## Get all project objects
func get_project_objects():
    var all_objects: Array[String] = []

    for object_type in GameObjectsLoader.game_objects:
        # Iterate through all game objects in the type
        var object_index: int = 0
        for game_object in GameObjectsLoader.game_objects[object_type]:
            var current_object: Dictionary = GameObjectsLoader.game_objects[object_type][game_object]
            all_objects.append(current_object[GameObjectsLoader.prop_description])
            objects_metadata[str(object_index)] = {
                GameObjectsLoader.prop_object_url: current_object[GameObjectsLoader.prop_object_url]
            }
            object_index += 1

    return all_objects
```

* This data on its own only creates a game object index. It does not store information about variables or code functions.

### Object Code and Variable detection logic

* The script path at has an index of internal resource pack references (`res://game_objects/loader.gd`):

```gdscript
# An index of internal resource packs
const internal_resource_packs: Dictionary = {
    "physics": {
        prop_description: "Physics Pack with Kenney Assets",
        prop_loader: "res://game_objects/physics/loader.gd",
        prop_pack_player: "res://game_objects/physics/player.tscn"
    }
}
```

* The `res://game_objects/physics/loader.gd` file is as follows:

```gdscript
## Load all Game Object instances and metadata
func load_game_objects():
    return {
        GameObjectsLoader.prop_foreground: {
            "alien": {
                GameObjectsLoader.prop_description: "Alien Character",
                GameObjectsLoader.prop_object_url: "res://game_objects/physics/objects/alien.tscn",
            },
            # ... other objects
        },
        # ... background and tiles sections
    }

## Load all shared variables
func load_shared_variables():
    return {
        # ... Shared variables data
    }
```

* The `url` for each game object can load the instance of that object and get its metadata, which is in its `ObjectMetaData` node.

```gdscript
extends Node
class_name ObjectMetaData

# ... other metadata elements here

## Custom properties for the object
@export var custom_properties: Array[ObjectCustomProperty] = []
## Metadata of code functions
@export var code_functions: Array[ObjectCodeFunction] = []
## Variables to be used by the coding environment
@export var code_variables: Array[ObjectCustomProperty] = []
```

* Below are the other data structures

```gdscript
extends Resource
class_name ObjectCustomProperty

## Property name
@export var property_name: String = ""
## Property type
@export var property_type: SharedEnums.PropertyType = SharedEnums.PropertyType.TypeString
## Property value
@export var property_value: String = ""
## Is read only?
@export var property_read_only: bool = false
```

```gdscript
extends Resource
class_name ObjectCodeFunction

## Name of the function
@export var function_name: String = ""
## Inputs of the function
@export var function_outputs: Array[ObjectCustomProperty] = []
## Function parameters
@export var function_parameters: Array[ObjectCustomProperty] = []
```

### Executing custom functions

* The `ObjectFunctionality` node of each object has the following:

```gdscript
## Executes a function from the parent object
func execute_function(function_name: String, params: Dictionary = {}):
	return parent_node.call(function_name, params)
```

* `params` will be a key value pair dictionary with parameter name and value.
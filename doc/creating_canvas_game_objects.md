## Example packs

There are 2 example packs that demonstrate how to create objects for the canvas environment. These objects can be programmed:

* `platformer` pack: At `res://game_objects/platformer/` - Which is a sample platformer pack.
* `physics` pack: At `res://game_objects/physics/` - Which is a sample physics based pack.

These 2 packs can be used for inspiration for coding objects that are canvas aware.

## Creating Game Objects for the Canvas

This section details how to create a game object that interacts with the Game Design Canvas. A game object that will be used by the game canvas has to have the following nodes:

* `ObjectMetaData` instance of `res://designer_src/object_metadata.tscn` - This tracks the metadata of the object during design and run time.
* `ObjectFunctionality` instance of `res://designer_src/object_functionality.tscn` - This defines rotuine functionality of the object during the life-cycle of the object. For instance, it is the home of the `property_changed` signal, that allows the canvas to communicate of property changes for the object to respond to. This node also deals with message passing functionality between itself and canvas.
* `ObjectFunctionality` instance of `res://designer_src/object_functionality.tscn` - This defines rotuine functionality of the object during the life-cycle of the object. For instance, it is the home of the `property_changed` signal, that allows the canvas to communicate of property changes for the object to respond to. This node also deals with message passing functionality between itself and canvas.
* `ObjectCoder` instance of `res://coder_nodes/object_coder.tscn` - This node is the bridge between the visual coding environment and the object. It also specifies code functions and code variables in its node properties (as arrays).
* Instance of the `RectExtents2D` node - This node will define the initial bounds the object occupy within the design canvas, to allow selection, positioning and rotation with the mouse. Note that these dimensions can change in the code. An example of dynamic dimensions are demonstrated with tile nodes in the `platformer` and `physics` packs.

![Node demonstration](images/canvas_node_components.png?raw=true "Node demonstration")

### Motivation for seperate objects

These nodes are created seperately so that they can have flexibility to grow independenly in future versions, and to create a clear seperation of concerns.

### `ObjectCoder`

* The `ObjectCoder` object has the `code_functions` and `code_variables` properties. `code_functions` are an array of  `ObjectCodeFunction` resource and `code_variables` are an array of `ObjectCustomProperty` resource.
* It also contains the `broadcast` which is used to handle broadcast events triggered form the visual coder.
* The code contained in the `code_functions` entries will be defined in the parent object's script. The following is an example of the `die` function for a player:

```gdscript
## Player dies
func die(params: Dictionary):
	# Implement the code functionality
    # The params parameter will contain a dictionary of the parameters passed form the visual code editor's node
```

## Creating new Game Objects and loading them into the canvas environment

Game objects can be defined in the `/game_objects` folder. It is recommended that each different game content pack has its own folder, as it is with the `physics` and `platformer` packs.

### Loading game packs

Notice the following lines in the `res://game_objects/loader.gd` file:

```gdscript
const internal_resource_packs: Dictionary = {
	"platformer": {
		prop_description: "Platformer Pack with Kenney Assets",
		prop_loader: "res://game_objects/platformer/loader.gd",
		prop_pack_player: "res://game_objects/platformer/player.tscn"
	},
	"physics": {
		prop_description: "Physics Pack with Kenney Assets",
		prop_loader: "res://game_objects/physics/loader.gd",
		prop_pack_player: "res://game_objects/physics/player.tscn"
	},
}
```

* the `prop_loader` property contains the script path to the loader, which initializes objects within that pack. For instance, for the `platformer` pack, it will be : `res://game_objects/platformer/loader.gd`.
* The loader script file will contain:
    * `load_game_objects` function: Which organizes the various objects to be loaded into different categories.
    * `load_shared_variables` function: Defining shared variables (Global Variables) in the pack.
    * `load_code_entry_points` function: Defining the custom code entry points that will be registered in the visual coder.

## Running the game while bypassing the editing environment

Running the game while bypassing the editing environment is possible. The 2 sample packs each have a `player` node instance that you can embed into your game environment.

* The platformer pack player is at: `res://game_objects/platformer/player.tscn`
* The physics pack player is at: `res://game_objects/physics/player.tscn`

You will only need to specify 2 properties for these players:

* `project_path`: Path to the saved project on disk.
* `scene_name`: Name of the startup scene.

## Game Customization: Implementing an `exit` for the launcher

You may want to implement a custom experience for your game, and then implement a custom integration with the project launcher, and handle an exit from the launcher back to your game experience:

* You can embed the Launcher interface (`res://launcher.tscn`) into your scene and set the `custom_exit_active` property to true. This will show the `exit` button on the launcher.
* You can then handle the `exit_pressed` signal.
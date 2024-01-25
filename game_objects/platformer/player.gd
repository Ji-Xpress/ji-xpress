extends Control

## Project folder path
@export var project_path: String = ""
## Project scene name
@export var scene_name: String = ""
## Reference to the canvas node
@onready var canvas_ui: Control = $CanvasUI


# Called when the node enters the scene tree for the first time.
func _ready():
	if project_path.strip_edges(true, true) != "":
		if ProjectManager.open_project(project_path):
			canvas_ui.scene_name = scene_name + Constants.scene_extension
			canvas_ui.populate_scene_nodes()

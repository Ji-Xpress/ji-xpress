extends Resource
class_name SceneMetaData

## Version of the app used to create the scene metadata
@export var app_version: String = ""
## Code file references
@export var code_files: Array[String] = []
## Reference to nodes present in the scene
@export var nodes: Array[ObjectProperties] = []


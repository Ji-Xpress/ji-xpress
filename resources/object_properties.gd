extends Resource
class_name ObjectProperties

# Shared properties
## Node ID identifier linking it to a specific node ID (internal)
@export var node_id: String = ""
## Object unique identifier to be used in canvas and code
@export var object_id: String = ""
## Rotation on canvas
@export var rotation: float = 0.0
## Position in canvas
@export var position: Vector2 = Vector2.ZERO
## Code file references
@export var code_files: Array[String] = []

## Custom properties
@export var custom_properties: Array[ObjectCustomProperty] = []

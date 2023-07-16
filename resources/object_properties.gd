extends Resource
class_name ObjectProperties

# Shared properties
## Node ID identifier linking it to a specific node ID
@export var node_id: String = ""
## Object uniqye identifier
@export var object_id: String = ""
## Rotation on canvas
@export var rotation: Vector2 = Vector2.ZERO
## Position in canvas
@export var position: Vector2 = Vector2.ZERO
## Code file references
@export var code_files: Array[String] = []

## Custom properties
@export var custom_properties: Array[ObjectCustomProperty] = []

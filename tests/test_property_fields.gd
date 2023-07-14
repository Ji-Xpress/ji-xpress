extends Control

var properties: Dictionary = {
	"property_num_one": {
		"type" : SharedEnums.PropertyType.TypeString,
		"value": "strval"
	},
	"property_num_two": {
		"type" : SharedEnums.PropertyType.TypeInt,
		"value": 5
	},
	"property_num_three": {
		"type" : SharedEnums.PropertyType.TypeFloat,
		"value": 0.3
	},
	"property_num_four": {
		"type" : SharedEnums.PropertyType.TypeDropDown,
		"value": {
			"val_a": "Value",
			"val_b": "Value b",
			"val_c": "Value c",
			"val_d": "Value d"
		}
	}
}

@onready var properties_editor: Control = $PropertiesEditor


# Called when the node enters the scene tree for the first time.
func _ready():
	for prop in properties:
		var prop_data = properties[prop]
		properties_editor.add_property(prop, prop_data.type, prop_data.value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

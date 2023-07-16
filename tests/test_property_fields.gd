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
		"value": ["Value", "Value 2", "Value 3", "Value 4"]
	},
	"property_number_five": {
		"type" : SharedEnums.PropertyType.TypeBool,
		"value": true
	}
}

@onready var properties_editor: Control = $PropertiesEditor


# Called when the node enters the scene tree for the first time.
func _ready():
	for prop in properties:
		var prop_data = properties[prop]
		properties_editor.add_property(prop, prop_data.type, prop_data.value)


# Test chnage property value
func _on_properties_editor_property_changed(property_set_id, property_id, new_value):
	print("Set id :" + property_set_id + " / Prop ID:" + property_id + " / Value: " + str(new_value))

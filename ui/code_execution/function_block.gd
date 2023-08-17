extends BlockBase

const property_label_node: PackedScene = preload("res://designer_nodes/property_nodes/property_label.tscn")
const text_property_node: PackedScene = preload("res://designer_nodes/property_nodes/text_property.tscn")
const numeric_property_node: PackedScene = preload("res://designer_nodes/property_nodes/numeric_property.tscn")
const dropdown_property_node: PackedScene = preload("res://designer_nodes/property_nodes/dropdown_property.tscn")
const bool_property_node: PackedScene = preload("res://designer_nodes/property_nodes/bool_property.tscn")

@onready var function_name: Label = $FunctionName

## Contains reference to the code function instance, needed to populate the node
var code_function_instance: ObjectCodeFunction = null
## Dictionary to store property nodes
var property_controls: Dictionary = {}
## Contains the index of the output slot
var output_slot_index: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	block_type = block_type_function
	block_sub_type = code_function_instance.get(ObjectCodeFunction.prop_function_name)
	function_name.text = block_sub_type
	populate_controls()
	
	contains_true = true
	contains_false = false
	contains_finally = false
	
	# Inpit slot metadata
	input_ports = {
		"0": condition_true
	}
	
	super._ready()


## Populates all child controls
func populate_controls():
	# Populate all parameters
	for parameter_instance in code_function_instance.function_block_parameters:
		var instance_key: String = parameter_instance[ObjectCustomProperty.prop_prop_name]
		var property_control: Control = null
		
		var new_label: Label = Label.new()
		new_label.text = instance_key
		add_child(new_label)
		
		match parameter_instance[ObjectCustomProperty.prop_prop_type]:
			SharedEnums.PropertyType.TypeString:
				property_control = text_property_node.instantiate()
			SharedEnums.PropertyType.TypeInt:
				property_control = numeric_property_node.instantiate()
				property_control.step = 1
			SharedEnums.PropertyType.TypeFloat:
				property_control = numeric_property_node.instantiate()
				property_control.step = 0.001
			SharedEnums.PropertyType.TypeBool:
				property_control = bool_property_node.instantiate()
		
		property_controls[instance_key] = {
			"type": parameter_instance[ObjectCustomProperty.prop_prop_type],
			"control": property_control
		}
		
		add_child(property_control)
		
		output_slot_index += 2
	
	# Populate all outputs and exit ports
	var output_index: int = 0
	
	for output_metadata in code_function_instance.function_outputs:
		# Prepare the label
		var new_label: Label = Label.new()
		new_label.text = output_metadata
		new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		add_child(new_label)
		
		# Assign exit ports
		exit_ports[str(output_index)] = output_metadata
		exit_ports_with_results[output_metadata] = output_index
		
		output_index += 1
		
		# Create an output slot
		set_slot(output_slot_index + output_index, false, 0, Color.WHITE, true, 0, Color.WHITE)


## Gets the metadata of the block
func get_block_metadata():
	var metadata: Dictionary = {}
	
	for control_key in property_controls:
		var current_control: Control = property_controls[control_key].control
		match property_controls[control_key].type:
			SharedEnums.PropertyType.TypeString:
				metadata[control_key] = control_key.text
			SharedEnums.PropertyType.TypeInt:
				metadata[control_key] = control_key.value
			SharedEnums.PropertyType.TypeBool:
				metadata[control_key] = control_key.value
			SharedEnums.PropertyType.TypeFloat:
				metadata[control_key] = control_key.button_pressed
	
	return metadata


## Sets the metadata of the block
func set_block_metadata(metadata: Dictionary):
	for control_key in metadata:
		var value = metadata[control_key]
		match property_controls[control_key].type:
			SharedEnums.PropertyType.TypeString:
				property_controls[control_key].control.text = value
			SharedEnums.PropertyType.TypeInt:
				property_controls[control_key].control.value = value
			SharedEnums.PropertyType.TypeBool:
				property_controls[control_key].control.value = value
			SharedEnums.PropertyType.TypeFloat:
				property_controls[control_key].control.button_pressed = value

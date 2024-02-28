extends CodeEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	var code_higlighter: CodeHighlighter = CodeHighlighter.new()
	
	code_higlighter.keyword_colors = {
		"func": Color(1, 0.76470589637756, 0),
		"var": Color(1, 0.76470589637756, 0),
		"object": Color(0.68627452850342, 0.88235294818878, 0.68627452850342),
		"get_entry_param": Color(0.97254902124405, 0.5137255191803, 0.4745098054409),
		"do_broadcast": Color(0.97254902124405, 0.5137255191803, 0.4745098054409),
		"set_global_variable": Color(0.97254902124405, 0.5137255191803, 0.4745098054409),
		"get_global_variable": Color(0.97254902124405, 0.5137255191803, 0.4745098054409),
		"get_property": Color(0.97254902124405, 0.5137255191803, 0.4745098054409),
		"set_property": Color(0.97254902124405, 0.5137255191803, 0.4745098054409),
		"get_object_position": Color(0.97254902124405, 0.5137255191803, 0.4745098054409),
		"set_object_position": Color(0.97254902124405, 0.5137255191803, 0.4745098054409),
		"get_object_rotation": Color(0.97254902124405, 0.5137255191803, 0.4745098054409),
		"set_object_rotation": Color(0.97254902124405, 0.5137255191803, 0.4745098054409),
	}
	
	code_higlighter.symbol_color = Color(1, 0.76470589637756, 0)
	code_higlighter.number_color = Color(1, 0.76470589637756, 0)
	code_higlighter.function_color = Color(0.68627452850342, 0.88235294818878, 0.68627452850342)
	code_higlighter.member_variable_color = Color(0.68627452850342, 0.88235294818878, 0.68627452850342)
	
	syntax_highlighter = code_higlighter
	
	

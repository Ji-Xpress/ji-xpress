extends CodeEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	syntax_highlighter.keyword_colors = {
		"func": Color(1, 0.76470589637756, 0),
		"var": Color(1, 0.76470589637756, 0),
		"object": Color(0.68627452850342, 0.88235294818878, 0.68627452850342),
		"get_entry_param": Color(0.68627452850342, 0.88235294818878, 0.68627452850342),
		"do_broadcast": Color(0.68627452850342, 0.88235294818878, 0.68627452850342)
	}

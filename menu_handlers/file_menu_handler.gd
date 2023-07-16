extends MenuButton

var popup_menu: PopupMenu

signal save_pressed


# Called when the node enters the scene tree for the first time.
func _ready():
	popup_menu = get_popup()
	
	popup_menu.connect("index_pressed", func(index: int):
		match index:
			0:
				emit_signal("save_pressed")
		pass)

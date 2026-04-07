extends Control

@onready var cursor_container: CenterContainer = $CursorContainer
@onready var controller_key_note: RichTextLabel = $CursorContainer/TextureRect/ControllerKeyNote
@onready var keyboard_key_note: RichTextLabel = $CursorContainer/TextureRect/KeyboardKeyNote

func show_cursor():
	cursor_container.show()
func hide_cursor():
	cursor_container.hide()


func _ready():
	hide_cursor()
	
	GameMaster.device_type_changed.connect(
		func (is_controller: bool):
			if is_controller:
				keyboard_key_note.hide()
				controller_key_note.show()
			else:
				keyboard_key_note.show()
				controller_key_note.hide()
	)

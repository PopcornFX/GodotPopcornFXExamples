extends PKEmitter3D

func _on_trigger_button_activate() -> void:
	is_playing = true


func _on_trigger_button_deactivate() -> void:
	is_playing = false

extends StaticBody3D

signal activated
signal deactivated

const BUTTON_ON = preload("uid://gahk8a2brbb7")
const BUTTON_OFF = preload("uid://bgn33t3ll1lvl")

@export var toggle: bool = false
@export var active: bool = false:
	set(v):
		if toggle:
			if v && not active:
				activated.emit()
				$DemoButtonPillar/SM_Button.set_surface_override_material(2, BUTTON_ON)
			elif not v and active:
				deactivated.emit()
				$DemoButtonPillar/SM_Button.set_surface_override_material(2, BUTTON_OFF)
		elif active:
			activated.emit()
			$DemoButtonPillar/SM_Button.set_surface_override_material(2, BUTTON_ON)
			get_tree().create_timer(0.3).timeout.connect(
				func ():
					$DemoButtonPillar/SM_Button.set_surface_override_material(2, BUTTON_OFF)
			)
		active = v

func _on_interactable_interacted(_character: Node3D) -> void:
	if not toggle && not active:
		active = true
	elif toggle:
		if not active:
			active = true
		else:
			active = false

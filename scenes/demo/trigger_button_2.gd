extends StaticBody3D

signal activate
signal deactivate

const BUTTON_ON = preload("uid://gahk8a2brbb7")
const BUTTON_OFF = preload("uid://bgn33t3ll1lvl")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if (body.is_in_group(&"Player")):
		activate.emit()
		$DemoButtonPillar/SM_Button.set_surface_override_material(2, BUTTON_ON)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if (body.is_in_group(&"Player")):
		deactivate.emit()
		$DemoButtonPillar/SM_Button.set_surface_override_material(2, BUTTON_OFF)
		

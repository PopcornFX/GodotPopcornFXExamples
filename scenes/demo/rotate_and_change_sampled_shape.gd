extends MeshInstance3D

const SM_STATUE = preload("uid://cuppfnm6ce45u")
var box = mesh
var current_mesh

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_mesh = mesh

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate(Vector3(0, 1, 0), delta * deg_to_rad(20))


func _on_trigger_button_activate() -> void:
	if (current_mesh == box):
		current_mesh = SM_STATUE
	else:
		current_mesh = box
	mesh = current_mesh
	position = Vector3(0, 1.7, -0.531)
	$PKEmitter3D.attribute_list.attribute_samplers[0].shape = current_mesh
	$PKEmitter3D.is_playing = false
	$PKEmitter3D.is_playing = true

func _on_trigger_button_deactivate() -> void:
	pass # Replace with function body.

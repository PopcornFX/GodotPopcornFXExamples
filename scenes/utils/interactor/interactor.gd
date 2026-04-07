extends Node3D

signal pointed_object_changed(old_object: Node3D, new_object: Node3D)

@export var player_character: Node3D
@export var can_interact: bool = true

@onready var ray_cast: RayCast3D = $RayCast3D

var currently_pointed_object: Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if can_interact:
		var collider: Object = ray_cast.get_collider()
		if (collider is Interactable or collider == null) and collider != currently_pointed_object:
			var old := currently_pointed_object
			currently_pointed_object = collider
			if is_instance_valid(old):
				old._pointing_stopped(player_character)
			if is_instance_valid(currently_pointed_object):
				currently_pointed_object._pointing(player_character)
			pointed_object_changed.emit(old, currently_pointed_object)

func interact():
	if currently_pointed_object:
		currently_pointed_object._interacted(player_character)

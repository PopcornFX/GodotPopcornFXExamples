class_name Interactable
extends Area3D

signal interacted(character: Node3D)
signal pointing(character: Node3D)
signal pointing_stopped(character: Node3D)

func _ready():
	monitoring = false
	monitorable = true
	collision_mask = 0
	collision_layer = 0b1000

func _pointing_stopped(character: Node3D):
	pointing_stopped.emit(character)

func _pointing(character: Node3D):
	pointing.emit(character)

func _interacted(character: Node3D):
	interacted.emit(character)

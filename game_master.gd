extends Node

var map_list = PackedStringArray([
	"res://scenes/00_welcome.tscn",
	"res://scenes/01_effect.tscn",
	"res://scenes/02_emitter.tscn",
	"res://scenes/03_attributes.tscn",
	"res://scenes/04_samplers.tscn",
	"res://scenes/05_rendering.tscn"
	])
var current_map_index = 0
var is_controller: bool = false

signal device_type_changed(is_controller: bool)

func next_map():
	current_map_index += 1
	if (current_map_index >= map_list.size()):
		current_map_index = 0
	get_tree().change_scene_to_file(map_list[current_map_index])
	
func prec_map():
	current_map_index -= 1
	if (current_map_index < 0):
		current_map_index = map_list.size() - 1
	get_tree().change_scene_to_file(map_list[current_map_index])

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var curr_map = get_tree().current_scene.scene_file_path
	print("Current map = ", curr_map)
	var index = 0
	for map in map_list:
		if (curr_map == map):
			current_map_index = index
			break
		index += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if is_controller:
		if event is InputEventKey or event is InputEventMouse:
			is_controller = false;
			device_type_changed.emit(is_controller)
	else:
		if event is InputEventJoypadButton or event is InputEventJoypadMotion:
			print(is_controller)
			is_controller = true;
			device_type_changed.emit(is_controller)

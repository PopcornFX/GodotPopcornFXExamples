@tool
extends Node3D

const SM_U_ROOM_WALL = preload("uid://cmw58t0yrv6oj")
const SM_U_ROOM_WALL_END_TMP = preload("uid://dn3kegu3jhou2")
const SM_U_ROOM_WALL_2 = preload("uid://c6ftkd3ln3jfu")
const SM_DEMO_DIVIDER_1 = preload("uid://coep7kohfi0bg")
const SM_DEMO_DIVIDER_2 = preload("uid://gnib0vy8shas")
const SM_DEMO_ROOM_U = preload("uid://rfyj5luva2do")
const SM_DEMO_ROOM_L = preload("uid://dd6ub1bokooxq")
const SM_DEMO_ROOM_L_TRIM = preload("uid://o54eakm3ro11")
const SM_DEMO_ROOM_TRIM_2 = preload("uid://c0ha4auvs2pqx")
const SM_DEMO_ROOM_BACK_WALL = preload("uid://w6k10kespqmx")
const SM_DEMO_ROOM_BACK_WALL_2 = preload("uid://bxg2a4fqni5xn")
const SM_DEMO_ROOM_CLAMP = preload("uid://dm627030evvet")
const SM_DEMO_ROOM_CLAMP_2 = preload("uid://c2lcxypv8y348")

enum room_type { STANDARD, ROOF_WITH_HOLE, ROOF_OPEN }

@onready var room: Node3D

# Also sets the owner of the child to the edited scene's root.
func add_child_tool(parent: Node, node: Node):
	if (!Engine.is_editor_hint()):
		return
	parent.add_child(node)
	
	(func ():
		node.owner = get_tree().edited_scene_root
	).call_deferred()

func add_room_names():
	pass
	
func add_loop_sections(offset: float, index: int):
	for loop_index in room_size:
		var room_u = SM_DEMO_ROOM_L.instantiate() if open_roof else SM_DEMO_ROOM_U.instantiate()
		var location = section_width * loop_index + trim_width
		location.x += offset;
		room_u.position = location
		room_u.scale = scale
		add_child_tool(room, room_u)
	
func add_trim(offset: float, index: int):
	var front_trim_mesh
	var back_trim_mesh
	front_trim_mesh = SM_DEMO_ROOM_TRIM_2.instantiate()
	back_trim_mesh = SM_DEMO_ROOM_TRIM_2.instantiate()
	if (!double_height):
		front_trim_mesh.scale.y /= 2.0
		back_trim_mesh.scale.y /= 2.0
	# Add front trim
	front_trim_mesh.translate(Vector3(offset, 0, 0))
	add_child_tool(room, front_trim_mesh)
	
	# Add back trim
	if (!open_back && index == number_of_rooms - 1):
		var location = trim_width + section_width * room_size;
		location.x += offset
		back_trim_mesh.translate(location)
		add_child_tool(room, back_trim_mesh)
	
func add_front_wall(offset: float, index: int):
	var first_wall_mesh
	var second_wall_mesh
	if (double_height):
		first_wall_mesh = SM_U_ROOM_WALL_2.instantiate()
		second_wall_mesh = SM_U_ROOM_WALL_2.instantiate()
	else:
		first_wall_mesh = SM_U_ROOM_WALL.instantiate()
		second_wall_mesh = SM_U_ROOM_WALL_END_TMP.instantiate()
	
	# Add front wall
	if (index == 0 && !front_door):
		first_wall_mesh.translate(Vector3(offset, 0, 0))
		first_wall_mesh.scale = Vector3(-scale.x, scale.y, scale.z)
		#var mat = second_wall_mesh.get_child(0).get_active_material(0).duplicate(true)
		#mat.set_shader_parameter("mirror_logo", true)
		#second_wall_mesh.get_child(0).mesh.surface_set_material(0, mat)
		if (scale.y < 0.0):
			first_wall_mesh.get_child(0).get_active_material(0).set_shader_parameter("show_logo", false)
		add_child_tool(room, first_wall_mesh)
		
	# Add back wall
	if (!open_back && number_of_rooms - 1 == index):
		var location = trim_width * 2 + section_width * room_size
		location.x += offset
		second_wall_mesh.translate(location)
		add_child_tool(room, second_wall_mesh)
		
	if (glass_walls):
		# TODO set mat to glass
		pass
	
	# Add room divider
	if (index > 0 && offset > 0.0):
		var divider
		if (mirror_room):
			divider = SM_DEMO_DIVIDER_2.instantiate()
		else:
			divider = SM_DEMO_DIVIDER_1.instantiate()
		#var divider_scale = Vector3(-scale.x, scale.y, scale.z)
		divider.scale.x *= -1
		divider.get_child(0).set_instance_shader_parameter("show_logo", false)
		var location = Vector3(-offset - 1.5, 0.0, 0.0)
		divider.translate(location)
		add_child_tool(room, divider)
	
	# Add front door
	if (front_door):
		if (mirror_room):
			add_child_tool(room, SM_DEMO_DIVIDER_2.instantiate())
		else:
			add_child_tool(room, SM_DEMO_DIVIDER_1.instantiate())
			
func add_back_wall(offset: float):
	var wall_mesh
	if (double_height):
		wall_mesh = SM_DEMO_ROOM_BACK_WALL_2.instantiate()
	else:
		wall_mesh = SM_DEMO_ROOM_BACK_WALL.instantiate()
	var location = trim_width;
	location.x += offset
	wall_mesh.position = location
	wall_mesh.scale = Vector3(section_width.x * room_size / (1750.0 / 100.0), 1.0, 1.0)
	add_child_tool(room, wall_mesh)
	
func add_clamp_wall(offset: float, index: int):
	var front_mesh
	if (double_height):
		front_mesh = SM_DEMO_ROOM_CLAMP_2.instantiate()
	else:
		front_mesh = SM_DEMO_ROOM_CLAMP.instantiate()
	front_mesh.translate(Vector3(offset, 0.0, 0.0))
	add_child_tool(room, front_mesh)
	
	if (!open_back && index == number_of_rooms - 1):
		var back_mesh
		if (double_height):
			back_mesh = SM_DEMO_ROOM_CLAMP_2.instantiate()
		else:
			back_mesh = SM_DEMO_ROOM_CLAMP.instantiate()
		back_mesh.translate(Vector3(offset + trim_width.x + room_size * section_width.x, 0.0, 0.0))
		add_child_tool(room, back_mesh)
				
func add_light(offset: float):
	var room_portion = room_size * section_width.x / 20.0
	var index = 1
	while (index <= clamp(floor(room_portion), 1, 50)):
		var location = Vector3()
		var fraction = room_portion - floor(room_portion)
		location.x = index * 20.0 - section_width.x * (fraction if room_size <= 1 else -fraction)
		location.x -= (room_size * section_width.x) / room_portion / 2.0 - 3
		location.x += offset
		location.y = 3.75
		location.z = -4.25
		if (!mirror_room):
			location.z += -8.5 / 2
		var light = OmniLight3D.new()
		light.position = location
		light.omni_range = light_radius
		light.omni_attenuation = 0.75
		#light.light_intensity_lumens = light_brightness
		light.light_energy = light_brightness
		light.shadow_enabled = cast_shadows
		light.light_specular = 3.0
		add_child_tool(room, light)
		index += 1
			
func open_trim():
	pass
	
func construction_script():
	# sanity check because this can be called directly from the setters
	if not is_instance_valid(room) or not is_instance_valid(get_tree()):
		return
	#sanity check : this is not the demo_room scene itself
	if self == get_tree().edited_scene_root:
		return
	
	for n in room.get_children():
		n.queue_free()
		
	for index in number_of_rooms:
		var offset : float = index * (room_size * section_width.x + trim_width.x)
		add_room_names()
		add_front_wall(offset, index)
		add_back_wall(offset)
		add_trim(offset, index)
		add_loop_sections(offset, index)
		if (mirror_room):
			pass
		else:
			add_clamp_wall(offset, index)
		if (lights):
			add_light(offset)

@export_group("Room properties")
@export_range(1, 30) var room_size : int = 4:
	set(value):
		room_size = value
		construction_script()
@export_range(1, 30) var number_of_rooms : int = 1:
	set(value):
		number_of_rooms = value
		construction_script()
@export var mirror_room : bool = false:
	set(value):
		mirror_room = value
		construction_script()
@export var lights : bool = true:
	set(value):
		lights = value
		construction_script()
@export var double_height : bool = false:
	set(value):
		double_height = value
		construction_script()
@export var open_roof : bool = false:
	set(value):
		open_roof = value
		construction_script()
@export var switch_colors : bool = false:
	set(value):
		switch_colors = value
		construction_script()
@export var glass_walls : bool = false:
	set(value):
		glass_walls = value
		construction_script()
@export var front_door : bool = false:
	set(value):
		front_door = value
		construction_script()
@export var open_back : bool = false:
	set(value):
		open_back = value
		construction_script()
@export var room_names : PackedStringArray:
	set(value):
		construction_script()
@export var room_types : Array[room_type]:
	set(value):
		construction_script()
		
@export_group("Light properties")
@export var cast_shadows : bool = true:
	set(value):
		cast_shadows = value
		construction_script()		
@export_range(0.01, 4096.0) var light_radius : float = 10.0:
	set(value):
		light_radius = value
		construction_script()
@export var light_brightness : float = 1.0:
	set(value):
		light_brightness = value
		construction_script()
		
@export_group("Sizes")
@export var section_width : Vector3 = Vector3(10, 0, 0):
	set(value):
		section_width = value
		construction_script()
@export var trim_width : Vector3 = Vector3(3, 0, 0):
	set(value):
		trim_width = value
		construction_script()

func setup_scene():
	if not has_node("Internal"):
		room = Node3D.new()
		room.name = "Internal"
		add_child(room)
		room.owner = get_tree().edited_scene_root
		construction_script.call_deferred()
	else:
		room = get_node("Internal")
		construction_script.call_deferred()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# This is unfortunately obligatory for good serialization from godot
	if (Engine.is_editor_hint()):
		setup_scene.call_deferred()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@tool
extends Node3D

const DEMO_DISPLAY_BASE_01 = preload("uid://ordkx4yk77yr")
const DEMO_DISPLAY_BASE_02 = preload("uid://ci0xqi05r7whx")
const DEMO_DISPLAY_BASE_03 = preload("uid://cwioflsoydycp")
const DEMO_DISPLAY_BASE_04 = preload("uid://csn83tqd8k6yr")
const SM_DEMO_DISPLAY_03_COMBINED = preload("uid://bmdpotuncf6wv")
const SM_NAME_PLATE = preload("uid://br4byjts4jt3w")

enum type { ROUND, SQUARE_L, ROOM_L, DESC_ONLY, SQUARE_L_FLAT_WALL }
@onready var internal: Node3D

# Also sets the owner of the child to the edited scene's root.
func add_child_tool(parent: Node, node: Node):
	if (!Engine.is_editor_hint()):
		return
	parent.add_child(node)
	
	(func ():
		node.owner = get_tree().edited_scene_root
	).call_deferred()

func create_desc_label() -> Label3D:
	var label : Label3D = Label3D.new()
	label.text = text
	label.font_size = 18
	label.translate(Vector3(0, 0.15, 0.025))
	label.rotate(Vector3(1, 0, 0), deg_to_rad(-33.0))
	return label
	
func create_title_label() -> Label3D:
	var label : Label3D = Label3D.new()
	label.text = title
	label.modulate = Color("b53c00")
	label.font_size = 100
	label.position = Vector3(-2.5, 3.333, -3.551)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	return label

func construction_script():
	# sanity check because this can be called directly from the setters
	if not is_instance_valid(internal) or not is_instance_valid(get_tree()):
		return
	#sanity check : this is not the demo_room scene itself
	if self == get_tree().edited_scene_root:
		return
	
	for n in internal.get_children():
		n.queue_free()

	match type_val:
		type.ROUND:
			var base_mesh = DEMO_DISPLAY_BASE_02.instantiate()
			add_child_tool(internal, base_mesh)
			var description_plate = SM_NAME_PLATE.instantiate()
			description_plate.translate(Vector3(0, 59 / 200.0, 330 / 200.0))
			if (show_desc):
				var description_label = create_desc_label()
				add_child_tool(description_plate, description_label)
			add_child_tool(base_mesh, description_plate)
			
		type.SQUARE_L:
			var base_mesh = DEMO_DISPLAY_BASE_01.instantiate()
			add_child_tool(internal, base_mesh)
			base_mesh.translate(Vector3(0, -25 / 200.0, 0))
			var description_plate = SM_NAME_PLATE.instantiate()
			description_plate.translate(Vector3(0, 29 / 100.0, 268 / 200.0))
			if (show_desc):
				var description_label = create_desc_label()
				add_child_tool(description_plate, description_label)
			add_child_tool(base_mesh, description_plate)
			if (show_title):
				var title_label = create_title_label()
				add_child_tool(base_mesh, title_label)
		type.ROOM_L:
			var base_mesh = DEMO_DISPLAY_BASE_04.instantiate()
			add_child_tool(internal, base_mesh)
		type.DESC_ONLY:
			var base_mesh = SM_NAME_PLATE.instantiate()
			add_child_tool(internal, base_mesh)
			if (show_desc):
				var description_label = create_desc_label()
				add_child_tool(base_mesh, description_label)
		type.SQUARE_L_FLAT_WALL:
			var base_mesh = SM_DEMO_DISPLAY_03_COMBINED.instantiate()
			add_child_tool(internal, base_mesh)
			base_mesh.translate(Vector3(0, -25 / 200.0, 0))
			var description_plate = SM_NAME_PLATE.instantiate()
			description_plate.translate(Vector3(0, 29 / 100.0, 268 / 200.0))
			if (show_desc):
				var description_label = create_desc_label()
				add_child_tool(description_plate, description_label)
			add_child_tool(base_mesh, description_plate)

@export var type_val: type = type.ROUND:
	set(value):
		type_val = value
		construction_script()

@export var show_desc : bool = true:
	set(value):
		show_desc = value
		construction_script()
		
@export var show_title : bool = true:
	set(value):
		show_title = value
		construction_script()
		
@export var title : String = "Title":
	set(value):
		title = value
		construction_script()
		
@export var text : String = "1. A Default Text Description":
	set(value):
		text = value
		construction_script()

func setup_scene():
	if not has_node("Internal"):
		internal = Node3D.new()
		internal.name = "Internal"
		add_child(internal)
		internal.owner = get_tree().edited_scene_root
		construction_script.call_deferred()
	else:
		internal = get_node("Internal")
		construction_script.call_deferred()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for n in get_children(true):
		if (n.name.begins_with("@")):
			n.queue_free()
	if (Engine.is_editor_hint()):
		setup_scene.call_deferred()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

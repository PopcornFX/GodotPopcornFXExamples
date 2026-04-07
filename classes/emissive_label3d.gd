@tool
class_name EmissiveLabel3D
extends Label3D

const EMISSIVE_TEXT_SHADER = preload("uid://dux5mv57fqm3x")
const EMISSIVE_TEXT = preload("uid://peaf1ccqx50r")

@export var refresh : bool:
	set(value):
		refresh = value
		_set_mat()
		
@export var emissive_intensity : float = 1.0:
	set(value):
		emissive_intensity = value
		_set_mat()

func _set_mat():
	material_overlay = EMISSIVE_TEXT_SHADER
	pass
	#material_overlay = StandardMaterial3D.new()
	#material_overlay.emission_enabled = true
	#material_overlay.emission = Color("b53c00")
	#material_overlay.emission_energy_multiplier = emissive_intensity
	#material_overlay.cull_mode = BaseMaterial3D.CULL_DISABLED
	#material_overlay.disable_ambient_light = true
	#material_overlay.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	#material_overlay.ao_enabled = true
	#material_overlay.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#material_overlay = mat
	pass

func _init() -> void:
	text = "Default desc"
	#material_overlay = mat

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

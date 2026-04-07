extends CharacterBody3D

@onready var interactor: Node3D = $Camera/Interactor
@onready var ui: Control = $UI

@export var normal_speed = 8.0
@export var run_speed = 15.0
var SPEED = normal_speed
const JUMP_VELOCITY = 4.5

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)


	move_and_slide()

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed(&"interact"):
		interactor.interact()
	elif event.is_action_pressed(&"previous_map"):
		GameMaster.prec_map()
	elif event.is_action_pressed(&"next_map"):
		GameMaster.next_map()
		
	elif event.is_action_pressed(&"fullscreen"):
		if DisplayServer.window_get_mode(0) != DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN, 0)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED, 0)
	elif event.is_action_pressed(&"sprint"):
		SPEED = run_speed
	elif event.is_action_released(&"sprint"):
		SPEED = normal_speed
	
func _on_interactor_pointed_object_changed(old_object: Node3D, new_object: Node3D) -> void:
	if new_object:
		ui.show_cursor()
	else:
		ui.hide_cursor()

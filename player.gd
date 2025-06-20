extends CharacterBody3D

@export var speed: float = 5.0
@export var crouch_speed: float = 2.5
@export var jump_force: float = 10.0
@export var gravity: float = -24.8
@export var mouse_sensitivity: float = 0.3

var yaw: float = 0.0
var pitch: float = 0.0
var is_crouching: bool = false

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var flashlight: SpotLight3D = $Head/Flashlight

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, -90, 90)

		rotation_degrees.y = yaw
		head.rotation_degrees.x = pitch

	if event.is_action_pressed("Flashlight"):
		flashlight.visible = !flashlight.visible

	if event.is_action_pressed("crouch"):
		is_crouching = !is_crouching

func _physics_process(delta: float) -> void:
	var input_dir = Vector3.ZERO

	if Input.is_action_pressed("move_forward"):
		input_dir.z -= 1
	if Input.is_action_pressed("move_back"):
		input_dir.z += 1
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1

	input_dir = input_dir.normalized()
	var move_dir = (transform.basis * input_dir).normalized()

	# Choose correct speed
	var current_speed: float
	if is_crouching:
		current_speed = crouch_speed
	else:
		current_speed = speed

	velocity.x = move_dir.x * current_speed
	velocity.z = move_dir.z * current_speed

	# Apply gravity and jump
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_force
		else:
			velocity.y = 0.0
	else:
		velocity.y += gravity * delta

	move_and_slide()

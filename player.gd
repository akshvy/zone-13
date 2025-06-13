extends CharacterBody3D

@export var speed: float = 5.0
@export var gravity: float = -24.8
@export var mouse_sensitivity: float = 0.3

var yaw: float = 0.0    # Left/Right rotation
var pitch: float = 0.0  # Up/Down rotation

@onready var head: Node3D = $Head

func _ready() -> void:
	# Lock the mouse to the center and hide it
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, -90, 90)

		rotation_degrees.y = yaw               # rotate body (left/right)
		head.rotation_degrees.x = pitch       # rotate head (up/down)

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

	# Rotate input direction based on where player is looking
	var direction = (transform.basis * input_dir).normalized()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0

	move_and_slide()

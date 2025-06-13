extends Node3D

@export var rock_scene: PackedScene
@export var area_size: float = 100.0
@export var rock_count: int = 50

func _ready():
	for i in rock_count:
		var rock_instance = rock_scene.instantiate()
		
		var x = randf_range(-area_size / 2, area_size / 2)
		var z = randf_range(-area_size / 2, area_size / 2)
		var y = 0  # Adjust if your terrain has height variation
		
		rock_instance.position = Vector3(x, y, z)
		rock_instance.rotate_y(randf_range(0, TAU))
		rock_instance.scale = Vector3.ONE * randf_range(0.8, 1.3)

		add_child(rock_instance)

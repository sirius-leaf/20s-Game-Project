extends RigidBody2D

@onready var camera: Camera2D = $"../Player/Player Camera"

func _process(delta):
	global_position.x = camera.global_position.x

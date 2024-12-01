extends Node2D

@onready var camera: Camera2D = $"../Player/Player Camera"

func _process(delta):
	var distanceToPlayer := camera.global_position.x - global_position.x
	
	if distanceToPlayer > 256.0:
		global_position.x += 256.0
	elif distanceToPlayer < -256.0:
		global_position.x -= 256.0

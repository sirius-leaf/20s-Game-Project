extends StaticBody2D

@export var missleScene: PackedScene

var _missle: Area2D

@onready var missle_spawner = $"Missle Spawner"

func _on_fire_rate_timeout():
	shoot()


func shoot():
	_missle = missleScene.instantiate()
	
	_missle.global_position = missle_spawner.global_position
	_missle.global_rotation = missle_spawner.global_rotation
	
	$"../".add_child(_missle)

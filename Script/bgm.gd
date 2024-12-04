extends AudioStreamPlayer2D

@onready var player: RigidBody2D = $"../Player"

func _process(delta: float) -> void:
	#pass
	global_position = Vector2(player.position)
	#global_position = plPos

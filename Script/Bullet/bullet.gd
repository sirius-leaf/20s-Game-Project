extends Area2D

@export var moveSpeed: float

func _physics_process(delta):
	global_position += Vector2(moveSpeed * cos(global_rotation),
			moveSpeed * sin(global_rotation)) * delta


func _on_life_time_timeout():
	queue_free()

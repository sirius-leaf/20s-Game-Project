extends Node2D

var hit := true

@onready var raycast: RayCast2D = $RayCast2D
@onready var line: Line2D = $Line2D

func _process(delta):
	if hit:
		var hitPoint: float = global_position.distance_to(
				raycast.get_collision_point()) if raycast.is_colliding() else 512.0
		var collideWith: Object = raycast.get_collider()
		
		# reduce player health when hit
		if collideWith != null and collideWith.has_method("ReduceHealth"):
			collideWith.ReduceHealth(2)
			$"../Player Camera".shakeMultiplier = 0.7
		
		# set laser line to hit point
		line.points[1] = Vector2(hitPoint, 0.0)
		
		hit = false


func _on_life_time_timeout():
	queue_free()

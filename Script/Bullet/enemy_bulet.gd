extends "res://Script/Bullet/bullet.gd"

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.healthValue -= 1
		$"../Player Camera".shakeMultiplier = 0.5
	
	queue_free()

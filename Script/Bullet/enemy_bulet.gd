extends "res://Script/Bullet/bullet.gd"

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.healthValue -= 1
	
	queue_free()

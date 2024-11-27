extends "res://Script/Bullet/enemy_bulet.gd"



func _ready():
	pass


func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("Turret") or body.is_in_group("PowerSource"):
		body.health -= 1
	
	if not body.is_in_group("Player"):
		queue_free()

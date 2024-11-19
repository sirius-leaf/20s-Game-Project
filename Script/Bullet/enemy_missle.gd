extends "res://Script/Bullet/bullet.gd"

@export var rotateSpeed: float

@onready var player: RigidBody2D = $"../Player"
@onready var direction_guide: Node2D = $"Direction Guide"

func _process(delta):
	direction_guide.look_at(player.global_position)
	
	if direction_guide.rotation > 0:
		rotate(rotateSpeed * delta)
	else:
		rotate(-rotateSpeed * delta)


func _on_body_entered(body):
	#queue_free()
	
	pass

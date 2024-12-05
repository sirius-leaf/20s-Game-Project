extends StaticBody2D

@export var explosionScene: PackedScene

var health := 5

func _process(delta):
	if health <= 0:
		var explosion: CPUParticles2D = explosionScene.instantiate()
		explosion.global_position = global_position
		get_tree().root.get_child(0).add_child(explosion)
		explosion.restart()
		
		$"../Player Camera".shakeMultiplier = 1.0
		$"../Player".powerSourceDestroyed += 1
		queue_free()

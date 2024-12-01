extends StaticBody2D

var health := 5

func _process(delta):
	if health <= 0:
		$"../Player".powerSourceDestroyed += 1
		queue_free()

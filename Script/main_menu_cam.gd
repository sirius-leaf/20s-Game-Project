extends Camera2D

@export var speed := 300.0

func _physics_process(delta: float) -> void:
	position.x += speed * delta

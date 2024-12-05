extends Camera2D

@export var shakePower: float

var shakeMultiplier := 0.0

var _shake := Vector2(0.0, 0.0)
var _shake2 := Vector2(0.0, 0.0)
var _shake2Temp := Vector2(0.0, 0.0)

@onready var player: RigidBody2D = $"../Player"

func _process(delta: float) -> void:
	global_position = player.position + _shake + _shake2
	
	shakeMultiplier = shakeMultiplier - delta * 2 if shakeMultiplier > 0.0 else 0.0


func _physics_process(delta: float) -> void:
	_shake = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * shakePower * shakeMultiplier
	_shake2 = lerp(_shake2, _shake2Temp, 0.1)


func _on_constant_shake_timer_timeout() -> void:
	_shake2Temp = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * 10.0

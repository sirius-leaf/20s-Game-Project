extends Camera2D

@export var shakePower: float

var shakeMultiplier := 0.0

var _shake := Vector2(0.0, 0.0)
var _shake2 := Vector2(0.0, 0.0)
var _shake2Temp := Vector2(0.0, 0.0)
var _zoomValue := Vector2(1.3, 1.3)

@onready var player: Player = $"../Player"
@onready var global_setting: GlobalSetting = $"../GlobalSetting"

func _process(delta: float) -> void:
	if player.move:
		if global_setting.play:
			global_position = player.position + _shake + _shake2
	else:
		_zoomValue = Vector2(2.0, 2.0)
		var bomb = get_parent().get_node("PlayerBomb")
		if bomb != null: global_position = bomb.global_position
	
	shakeMultiplier = shakeMultiplier - delta * 2 if shakeMultiplier > 0.0 else 0.0


func _physics_process(delta: float) -> void:
	_shake = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * shakePower * shakeMultiplier
	_shake2 = lerp(_shake2, _shake2Temp, 0.1)
	
	zoom = lerp(zoom, _zoomValue, 0.05)


func _on_constant_shake_timer_timeout() -> void:
	_shake2Temp = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * 10.0

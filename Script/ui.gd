extends Control

var _timerStart := true

@onready var timer_label: Label = $"Timer Label"
@onready var health_label: Label = $"Health Label"
@onready var _player: RigidBody2D = $"../../Player"
@onready var global_setting: GlobalSetting = $"../../GlobalSetting"
@onready var timer: Timer = $"Timer Label/Timer"

func _process(delta: float) -> void:
	if global_setting.play and _timerStart:
		timer.start()
		
		_timerStart = false
	
	timer_label.text = str(floor(timer.time_left * 100) / 100)
	health_label.text = "Helath : " + str(_player.healthValue)

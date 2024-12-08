extends Control

var _timerStart := true

@onready var _player: RigidBody2D = $"../../Player"
@onready var global_setting: GlobalSetting = $"../../GlobalSetting"
@onready var timer: Timer = $TimerBar/Timer
@onready var timer_bar: ProgressBar = $TimerBar
@onready var health_bar: ProgressBar = $HealthBar
@onready var clock_hand: Control = $Control/ClockHand
@onready var timer_text: Label = $TimerText

func _process(delta: float) -> void:
	var timeLeft := 20.0
	
	if global_setting.play:
		if _timerStart:
			timer.start()
			_timerStart = false
		
		timeLeft = timer.time_left
		clock_hand.rotation_degrees += 360.0 * delta
		timer_text.text = str(floor(timeLeft * 10) / 10)
	
	timer_bar.value = timeLeft
	health_bar.value = _player.healthValue


func _on_timer_timeout() -> void:
	if global_setting.play:
		global_setting.timeEnd = true

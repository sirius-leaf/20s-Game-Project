extends Control

@export var powerSourceBar: Array[Control]

var _timerStart := true
var _mode: int = 1

@onready var player: Player = $"../../Player"
@onready var global_setting: GlobalSetting = $"../../GlobalSetting"
@onready var timer: Timer = $MainUI/TimerBar/Timer
@onready var timer_bar: ProgressBar = $MainUI/TimerBar
@onready var health_bar: ProgressBar = $MainUI/HealthBar
@onready var clock_hand: Control = $MainUI/Control/ClockHand
@onready var timer_text: Label = $MainUI/TimerText
@onready var drop_bomb_warning: Label = $MainUI/DropBombWarning
@onready var pause_button: Button = $MainUI/PauseButton
@onready var main_ui: Control = $MainUI
@onready var pause_ui: Control = $PauseUI

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
	health_bar.value = player.healthValue
	
	drop_bomb_warning.visible = true if player.insideTarget else false
	
	match player.powerSourceDestroyed:
		1:
			powerSourceBar[0].visible = false
		2:
			powerSourceBar[1].visible = false
		3:
			powerSourceBar[2].visible = false
	
	if Input.is_action_just_pressed("ui_cancel"):
		match _mode:
			1:
				pause()
			-1:
				play()
		_mode *= -1


func _on_timer_timeout() -> void:
	if global_setting.play:
		global_setting.timeEnd = true


func _on_pause_button_button_down() -> void:
	if not get_tree().paused: pause()


func _on_resume_button_down() -> void:
	if get_tree().paused: play()


func _on_main_menu_button_down() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/Level Scene/main_menu.tscn")
	print("ccc")


func pause() -> void:
	main_ui.visible = false
	pause_ui.visible = true
	get_tree().paused = true


func play() -> void:
	get_tree().paused = false
	main_ui.visible = true
	pause_ui.visible = false

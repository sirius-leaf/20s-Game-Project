extends Control

@export var gameScene: PackedScene

@onready var start: Control = $Start
@onready var mission: Control = $Mission
@onready var global_setting: GlobalSetting = $"../../GlobalSetting"
@onready var hard_mode: CheckBox = $Start/HardMode

func _process(delta: float) -> void:
	GlobalSet.ChaosMode = true if hard_mode.button_pressed else false

func _on_play_button_button_down() -> void:
	mission.visible = true
	start.visible = false


func _on_quit_button_button_down() -> void:
	get_tree().quit()


func _on_start_button_button_down() -> void:
	get_tree().change_scene_to_packed(gameScene)


func _on_back_button_button_down() -> void:
	mission.visible = false
	start.visible = true

class_name GlobalSetting

extends Node

@export var ChaosMode: bool

var play: bool = false
var timeEnd: bool = false

func _ready() -> void:
	var delay: float = 4.0 / 3.0
	await get_tree().create_timer(delay).timeout
	play = true

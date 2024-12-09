class_name GlobalSetting

extends Node

@export var ChaosMode: bool

var play: bool = false
var timeEnd: bool = false
var playerIsWin: bool = true

func _ready() -> void:
	ChaosMode = GlobalSet.ChaosMode
	var delay: float = 4.0 / 3.0
	await get_tree().create_timer(delay).timeout
	play = true

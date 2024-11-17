extends Node2D

signal random_number_set

var blockRandomStartPosition: Array[float] = [0.0, 0.0]
var blockRandomSpeed: Array[float] = [0.0, 0.0]

var _rng := RandomNumberGenerator.new()

func _ready():
	_rng.randomize()
	
	# set block random start pos
	for i in range(2):
		blockRandomStartPosition[i] = _rng.randf_range(0, 128.0)
		blockRandomSpeed[i] = _rng.randf_range(64.0, 128.0)
	
	emit_signal("random_number_set")
	
	# set block movement direction
	$"Moving Block".rotation_degrees = _rng.randi_range(0, 1) * 180.0
	$"Moving Block2".rotation_degrees = _rng.randi_range(0, 1) * 180.0

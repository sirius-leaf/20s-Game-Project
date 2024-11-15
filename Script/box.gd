extends RigidBody2D

var _rng = RandomNumberGenerator.new()
var _player: RigidBody2D
var _boxScale

func _ready():
	_player = $"../Level/Player"
	
	_rng.randomize()
	_boxScale = _rng.randf_range(0.25, 2.0)


func _process(delta):
	scale = Vector2(_boxScale, _boxScale)
	
	# delete object when outside the camera
	if global_position.x - _player.global_position.x < -500.0:
		queue_free()

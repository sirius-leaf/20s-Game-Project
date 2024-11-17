extends RigidBody2D

var _rng := RandomNumberGenerator.new()
var _rotateSpeed: float

func _ready():
	_rng.randomize()
	
	_rotateSpeed = _rng.randf_range(30.0, 60.0) * (1.0 - _rng.randi_range(0, 1) * 2.0)


func _physics_process(delta):
	rotate(deg_to_rad(_rotateSpeed) * delta)

extends Node2D

var _rng := RandomNumberGenerator.new()
var _startMovingBlockRotation: float
var _animationState: int = 1

@onready var _moving_block: Node2D = $"Moving Block"
@onready var _moving_block2: Node2D = $"Moving Block2"
@onready var _animation_player: AnimationPlayer = $"Moving Block/Block/AnimationPlayer"
@onready var _animation_player2: AnimationPlayer = $"Moving Block2/Block/AnimationPlayer"
@onready var _timer = $Timer

func _ready():
	_rng.randomize()
	
	_startMovingBlockRotation = _rng.randi_range(0, 1) * 180.0
	
	# set random rotation value for both moving block
	_moving_block.rotation_degrees = _startMovingBlockRotation
	_moving_block2.rotation_degrees = 180.0 - _startMovingBlockRotation
	
	# start the block moving animation
	_animation_player.play("move_1")
	_animation_player2.play("move_1")


func _on_animation_player_animation_finished(anim_name):
	_animationState *= -1
	_timer.wait_time = 1.0
	
	_timer.start()
	await _timer.timeout
	
	match _animationState:
		1:
			_animation_player.play("move_1")
			_animation_player2.play("move_1")
		-1:
			_animation_player.play("move_2")
			_animation_player2.play("move_2")

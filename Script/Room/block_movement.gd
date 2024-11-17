extends RigidBody2D

enum blockPos { FRONT, BACK }

@export var posEnum: blockPos = blockPos.FRONT

var _startPositionY: float
var _moveSpeed: float

@onready var room = $"../.."

func _ready():
	room.connect("random_number_set", _on_random_number_set)


func _process(delta):
	# move the block
	position.y += _moveSpeed * delta
	
	# set the block back up when too low
	if position.y > 384:
		position.y = -384


func _on_random_number_set():
	# set random variable based on enum value
	match posEnum:
		blockPos.FRONT:
			_startPositionY = room.blockRandomStartPosition[0]
			_moveSpeed = room.blockRandomSpeed[0]
		_:
			_startPositionY = room.blockRandomStartPosition[1]
			_moveSpeed = room.blockRandomSpeed[1]
	
	# set the start pos variable to block position
	position.y += _startPositionY

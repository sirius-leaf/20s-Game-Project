extends Node2D

enum RoomNumberEnum {
	ROOM_1,
	ROOM_4,
	ROOM_10,
}

@export var roomNumber: RoomNumberEnum = RoomNumberEnum.ROOM_1

var _rng := RandomNumberGenerator.new()

func _ready():
	_rng.randomize()
	
	# randomize wall start pos y based on room number
	match roomNumber:
		RoomNumberEnum.ROOM_1:
			$Wall.position.y = _rng.randf_range(-160.0, 160.0)
		RoomNumberEnum.ROOM_4:
			$Wall.position.y = (1 - _rng.randi_range(0, 1) * 2) * 256.0
		RoomNumberEnum.ROOM_10:
			$Wall.position.y = _rng.randf_range(-160.0, 160.0)
			$Wall2.position.y = _rng.randf_range(-160.0, 160.0)
			$Wall3.position.y = _rng.randf_range(-160.0, 160.0)

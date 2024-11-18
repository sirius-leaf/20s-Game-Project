extends Marker2D

@export var roomsScene: PackedScene

var _rng := RandomNumberGenerator.new()

var _roomNames: Array[String] = [
	"Room1",
	"Room2",
	"Room3",
	"Room4",
	"Room5",
	"Room6",
	"Room7",
	"Room8",
	"Room10",
]

@onready var _timer = $Timer

func _ready():
	_rng.randomize()
	
	spawn_room()


func spawn_room():
	var room: Node2D
	
	_timer.wait_time = 0.05
	_timer.start()
	await _timer.timeout
	
	for i in range(10):
		# set random room scene
		room = roomsScene.instantiate().get_node(_roomNames[
				_rng.randi_range(0, 8)]).duplicate()
		
		# spawn the room
		room.global_position = global_position
		get_parent().add_child(room)
		global_position.x += 768.0
		
		# delay
		_timer.wait_time = 0.05
		_timer.start()
		await _timer.timeout

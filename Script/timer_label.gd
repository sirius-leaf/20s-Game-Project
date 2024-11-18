extends Label

@onready var _player: RigidBody2D = $"../../../Player"

func _process(delta):
	match name:
		"Timer Label":
			text = str(floor($Timer.time_left * 100) / 100)
		"Health Label":
			text = "Helath : " + str(_player.healthValue)

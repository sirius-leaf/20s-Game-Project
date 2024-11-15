extends Label

func _process(delta):
	text = str(floor($Timer.time_left * 100) / 100)

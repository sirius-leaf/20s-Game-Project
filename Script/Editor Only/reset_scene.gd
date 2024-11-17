extends Node2D

var keyPressed: bool = false

func _process(delta):
	if Input.is_key_pressed(KEY_R):
		keyPressed = true
	elif keyPressed:
		get_tree().reload_current_scene()
		keyPressed = false

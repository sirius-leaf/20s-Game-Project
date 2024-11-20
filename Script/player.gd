extends RigidBody2D

@export var playerMoveSpeed: float

var healthValue: int = 20

func _process(delta):
	# input for player movement
	var moveInput := Vector2(Input.get_axis("ui_left", "ui_right"),
			Input.get_axis("ui_up", "ui_down"))
	
	# move the player
	if moveInput:
		apply_central_force(moveInput * playerMoveSpeed)
	
	# restart scene
	if Input.is_action_just_pressed("ui_restart"):
		get_tree().reload_current_scene()
	
	# rotate player to match move direction
	rotation_degrees = linear_velocity.x / 400 * 30


func ReduceHealth(damage: int):
	healthValue -= damage

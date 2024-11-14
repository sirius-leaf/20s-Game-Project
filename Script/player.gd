extends RigidBody2D

@export var playerMoveSpeed: float

func _ready():
	pass


func _process(delta):
	# input for player movement
	var moveInput := Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	
	# move the player
	apply_central_force(moveInput * playerMoveSpeed)
	
	# rotate player to match move direction
	rotation = atan2(linear_velocity.y, linear_velocity.x)


func _physics_process(delta):
	pass

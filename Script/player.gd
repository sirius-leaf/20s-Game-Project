extends RigidBody2D

@export var playerMoveSpeed: float
@export var bulletScene: PackedScene

var healthValue := 10

var _rng := RandomNumberGenerator.new()
var _shoot := false
var _direction := 1

@onready var bullet_spawner: Marker2D = $BulletSpawner
@onready var player_sprite: Sprite2D = $Player

func _process(delta):
	# input for player movement
	var moveInput := Vector2(Input.get_axis("ui_left", "ui_right"),
			Input.get_axis("ui_up", "ui_down"))
	
	_shoot = true if Input.is_key_pressed(KEY_SPACE) else false
	
	# move the player
	if moveInput:
		apply_central_force(moveInput * playerMoveSpeed)
		
		if not Input.is_key_pressed(KEY_SPACE):
			_direction = 1 if moveInput.x >= 0 else -1
			player_sprite.flip_h = true if moveInput.x < 0 else false
	
	bullet_spawner.position.x = 16.0 * _direction
	
	# restart scene
	if Input.is_action_just_pressed("ui_restart"):
		get_tree().reload_current_scene()
	
	# rotate player to match move direction
	rotation_degrees = linear_velocity.x / 400 * 30


func _on_fire_rate_timeout():
	if _shoot:
		shoot()


func ReduceHealth(damage: int):
	healthValue -= damage


func shoot():
	var bullet: Area2D = bulletScene.instantiate()
	bullet.global_position = bullet_spawner.global_position
	bullet.global_rotation_degrees = (90.0 - 45.0 * _direction) + _rng.randf_range(-3.0, 3.0)
	get_tree().root.get_child(0).add_child(bullet)

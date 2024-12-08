class_name Player

extends RigidBody2D

@export var playerMoveSpeed: float
@export var bulletScene: PackedScene
@export var explosionScene: PackedScene
@export var bombScene: PackedScene

var healthValue := 15
var insideTarget := false
var powerSourceDestroyed := 0
var move := true

var _rng := RandomNumberGenerator.new()
var _shoot := false
var _direction := 1
var _alive := true
var _bombDrop := true
var _gameOver := true

@onready var bullet_spawner: Marker2D = $BulletSpawner
@onready var player_sprite: Sprite2D = $Player
@onready var player_sfx: AudioStreamPlayer = $"../BGM/PlayerSFX"
@onready var player_collider: CollisionShape2D = $"Player Collider"
@onready var global_setting: GlobalSetting = $"../GlobalSetting"
@onready var glow: Sprite2D = $Glow

func _process(delta):
	if not global_setting.play:
		if position.x >= -45.0:
			constant_force.x = 0.0
		
		if position.y >= -20.0:
			constant_force.y = 0.0
	else:
		var moveInput := Vector2(Input.get_axis("ui_left", "ui_right"),
				Input.get_axis("ui_up", "ui_down"))
		
		if insideTarget:
			if _bombDrop and powerSourceDestroyed >= 3 and Input.is_action_pressed("ui_select"):
				drop_bomb()
				move = false
				constant_force = Vector2(2500.0, -1500.0)
				_bombDrop = false
		elif _bombDrop:
			if global_setting.timeEnd:
				if _gameOver:
					game_over()
					glow.visible = true
					_gameOver = false
				
				glow.scale += Vector2(12.0, 12.0) * delta
		
		_shoot = true if (Input.is_key_pressed(KEY_SPACE) and _alive and move) else false
		
		# move the player
		if moveInput and _alive and move:
			apply_central_force(moveInput * playerMoveSpeed)
			
			_direction = 1 if moveInput.x >= 0 else -1
			player_sprite.flip_h = true if moveInput.x < 0 else false
	
	bullet_spawner.rotation_degrees = (90.0 - 70.0 * _direction)
	bullet_spawner.position.x = 16.0 * _direction
	
	# restart scene
	if Input.is_action_just_pressed("ui_restart"):
		get_tree().reload_current_scene()
	
	# rotate player to match move direction
	rotation_degrees = linear_velocity.x / 400.0 * 30.0
	
	if healthValue <= 0 and _alive:
		game_over()
		_alive = false


func _on_fire_rate_timeout():
	if _shoot:
		shoot()


func _on_body_entered(body):
	if body.is_in_group("Target"): print("sfdjkdsfjkdsfjkhl")


func ReduceHealth(damage: int):
	healthValue -= damage


func shoot():
	var bullet: Area2D = bulletScene.instantiate()
	bullet.global_position = bullet_spawner.global_position
	bullet.global_rotation_degrees = bullet_spawner.global_rotation_degrees + \
			_rng.randf_range(-3.0, 3.0)
	get_tree().root.get_child(0).add_child(bullet)
	player_sfx.pitch_scale = _rng.randf_range(0.9, 1.1)
	player_sfx.play()


func game_over():
	player_sprite.visible = false
	player_collider.disabled = true
	
	var explosion: CPUParticles2D = explosionScene.instantiate()
	explosion.global_position = global_position
	get_tree().root.get_child(0).add_child(explosion)
	
	await get_tree().create_timer(1.0).timeout
	
	get_tree().reload_current_scene()


func drop_bomb():
	var bomb: RigidBody2D = bombScene.instantiate()
	bomb.global_position = global_position
	get_tree().root.get_child(0).add_child(bomb)

class_name Player_

extends CharacterBody2D

const SPEED = 400.0

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
@onready var player_sfx: AudioStreamPlayer = $"../BGM/PlayerSFX"
@onready var player_collider: CollisionShape2D = $"Player Collider"
@onready var global_setting: GlobalSetting = $"../GlobalSetting"
@onready var glow: Sprite2D = $Glow
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction := Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	if global_setting.play:
		if direction and _alive and move:
			velocity = lerp(velocity, direction * SPEED, 0.2)
			animation.flip_h = true if velocity.x < 0.0 else false
			bullet_spawner.rotation_degrees = 90 - 70 * direction.x
			bullet_spawner.position.x = 16 * direction.x
		elif not _bombDrop:
			velocity = Vector2(400.0, -300.0)
		else:
			velocity = lerp(velocity, Vector2(0.0, 0.0), 0.2)
		
		_shoot = true if Input.is_action_pressed("ui_accept") and not insideTarget else false
	else:
		velocity.x = 250.0 if global_position.x < -20 else lerp(velocity.x, 0.0, 0.2)
		velocity.y = 150.0 if global_position.y < -10 else lerp(velocity.y, 0.0, 0.2)
	
	if insideTarget:
		if Input.is_action_just_pressed("ui_accept") and _bombDrop:
			drop_bomb()
			_bombDrop = false
	elif global_setting.timeEnd and _bombDrop:
		if _alive:
			glow.visible = true
			GlobalSet.playerIsWin = false
			game_over(2.5, true)
			_alive = false
		
		glow.scale += Vector2(12.0, 12.0) * delta
	elif not _bombDrop and global_setting.timeEnd and _alive:
		win()
		_alive = false
	
	global_rotation_degrees = velocity.x / 400.0 * 20.0
	
	if Input.is_action_just_pressed("ui_restart"):
		get_tree().reload_current_scene()
	
	if healthValue <= 0 and _alive:
		game_over()
		_alive = false
	
	move_and_slide()


func _on_fire_rate_timeout() -> void:
	if _shoot:
		shoot()


func shoot():
	var bullet: Area2D = bulletScene.instantiate()
	bullet.global_position = bullet_spawner.global_position
	bullet.global_rotation_degrees = bullet_spawner.global_rotation_degrees + \
			_rng.randf_range(-3.0, 3.0)
	get_tree().root.get_child(1).add_child(bullet)
	player_sfx.pitch_scale = _rng.randf_range(0.9, 1.1)
	player_sfx.play()


func ReduceHealth(damage: int):
	healthValue -= damage


func drop_bomb():
	move = false
	
	var bomb: RigidBody2D = bombScene.instantiate()
	bomb.global_position = global_position
	get_tree().root.get_child(1).add_child(bomb)


func game_over(delay: float = 1.0, missionFail: bool = false):
	animation.visible = false
	player_collider.disabled = true
	
	var explosion: CPUParticles2D = explosionScene.instantiate()
	explosion.global_position = global_position
	get_tree().root.get_child(1).add_child(explosion)
	
	await get_tree().create_timer(delay).timeout
	
	if missionFail:
		GlobalSet.playerIsWin = false
		get_tree().change_scene_to_file("res://Scene/Level Scene/win_scene.tscn")
	else:
		get_tree().reload_current_scene()


func win() -> void:
	move = false
	
	await get_tree().create_timer(2.5).timeout
	
	GlobalSet.playerIsWin = true
	get_tree().change_scene_to_file("res://Scene/Level Scene/win_scene.tscn")

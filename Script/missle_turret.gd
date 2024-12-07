extends StaticBody2D

@export var missleScene: PackedScene
@export var explosionScene: PackedScene
@export var shotDelay := [0.0, 0.0]

var health := 3

var _missle: Area2D
var _rng := RandomNumberGenerator.new()
var _fireRateModifier: float
var _shootRangeMod: float

@onready var player: RigidBody2D = $"../Player"
@onready var missle_spawner = $"Missle Spawner"
@onready var fire_rate = $FireRate
@onready var sfx: AudioStreamPlayer2D = $MissleShot
@onready var global_setting: GlobalSetting = $"../GlobalSetting"

func _ready():
	var isChaosMode := global_setting.ChaosMode
	_fireRateModifier = 1.0 if isChaosMode else 0.0
	_shootRangeMod = 200.0 if isChaosMode else 0.0
	
	fire_rate.start()


func _process(delta):
	if health <= 0:
		var explosion: CPUParticles2D = explosionScene.instantiate()
		explosion.global_position = global_position
		get_tree().root.get_child(0).add_child(explosion)
		explosion.restart()
		
		$"../Player Camera".shakeMultiplier = 0.5
		
		queue_free()


func _on_fire_rate_timeout():
	var distanceToPlayer = global_position.distance_to(player.global_position)
	
	if distanceToPlayer <= 300.0 + _shootRangeMod:
		shoot()
		fire_rate.wait_time = _rng.randf_range(shotDelay[0] - _fireRateModifier,
				shotDelay[1] - _fireRateModifier)
		fire_rate.start()


func shoot():
	_missle = missleScene.instantiate()
	
	_missle.global_position = missle_spawner.global_position
	_missle.global_rotation = missle_spawner.global_rotation
	
	$"../".add_child(_missle)
	
	sfx.play()

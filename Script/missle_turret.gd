extends StaticBody2D

@export var missleScene: PackedScene
@export var shotDelay := [0.0, 0.0]

var health := 3

var _missle: Area2D
var _rng := RandomNumberGenerator.new()

@onready var player: RigidBody2D = $"../Player"
@onready var missle_spawner = $"Missle Spawner"
@onready var fire_rate = $FireRate

func _ready():
	fire_rate.start()


func _process(delta):
	if health <= 0:
		queue_free()


func _on_fire_rate_timeout():
	var distanceToPlayer = global_position.distance_to(player.global_position)
	
	if distanceToPlayer <= 300.0:
		shoot()
		fire_rate.wait_time = _rng.randf_range(shotDelay[0], shotDelay[1])
		fire_rate.start()


func shoot():
	_missle = missleScene.instantiate()
	
	_missle.global_position = missle_spawner.global_position
	_missle.global_rotation = missle_spawner.global_rotation
	
	$"../".add_child(_missle)

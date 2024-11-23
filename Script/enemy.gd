extends Node2D

enum Type {
	SHOOTER,
	EXPLODE
}

@export var enemyType: Type
@export var bulletScene: PackedScene 
@export var moveSpeed: float
@export var minDistanceToPlayer: float
@export var minDistanceToShoot: float

var _rng := RandomNumberGenerator.new()
var _fire := true
var _move := true

@onready var enemy_body: RigidBody2D = $EnemyBody
@onready var player: RigidBody2D = $"../Player"
@onready var area_2d: Area2D = $Area2D
@onready var bullet_spawner: Marker2D = $EnemyBody/BulletSpawner
@onready var fire_rate: Timer = $EnemyBody/FireRate

func _ready():
	_rng.randomize()


func _process(delta):
	enemy_body.global_rotation_degrees = enemy_body.linear_velocity.x / 200.0 * 30.0
	
	area_2d.global_transform = enemy_body.global_transform
	area_2d.global_rotation = enemy_body.global_rotation
	
	var directionToPlayer: Vector2 = enemy_body.global_position.direction_to(
			player.global_position)
	var distanceToPlayer: float = enemy_body.global_position.distance_to(
			player.global_position)
	var velocityX: float = enemy_body.linear_velocity.x
	
	_fire = true if distanceToPlayer <= minDistanceToShoot else false
	
	if enemyType == Type.EXPLODE and _fire:
		_move = false
		fire_rate.start()
	
	bullet_spawner.look_at(player.global_position)
	
	# move the enemy when is far from player
	if distanceToPlayer > minDistanceToPlayer and _move:
		enemy_body.apply_central_force(Vector2(directionToPlayer.x, directionToPlayer.y) 
				* moveSpeed)


func _on_fire_rate_timeout():
	match enemyType:
		Type.SHOOTER:
			if _fire:
				shoot()
		Type.EXPLODE:
			shoot()
			queue_free()


func shoot():
	var bullet: Area2D = bulletScene.instantiate()
	bullet.global_position = bullet_spawner.global_position
	bullet.global_rotation_degrees = bullet_spawner.global_rotation_degrees \
			+ _rng.randf_range(-3.0, 3.0)
	$"..".add_child(bullet)

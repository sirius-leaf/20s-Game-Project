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
@export var health := 5

var _rng := RandomNumberGenerator.new()
var _fire := true
var _move := true
var _explode := true

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
	
	# explosive enemy behavior
	if enemyType == Type.EXPLODE and _fire and _explode:
		_move = false
		fire_rate.start()
		_explode = false
	
	bullet_spawner.look_at(player.global_position)
	
	# move the enemy when is far from player
	if distanceToPlayer > minDistanceToPlayer and distanceToPlayer < 300.0 and _move:
		enemy_body.apply_central_force(Vector2(directionToPlayer.x, directionToPlayer.y) 
				* moveSpeed)
	
	if health <= 0:
		queue_free()


func _on_fire_rate_timeout():
	match enemyType:
		Type.SHOOTER:
			if _fire:
				shoot()
		Type.EXPLODE:
			shoot()
			$"../Player Camera".shakeMultiplier = 1.0
			queue_free()


func _on_area_2d_area_entered(area):
	if area.is_in_group("PlayerBullet"):
		health -= 1
		area.queue_free()


func shoot():
	var bullet: Area2D = bulletScene.instantiate()
	bullet.global_position = bullet_spawner.global_position
	bullet.global_rotation_degrees = bullet_spawner.global_rotation_degrees \
			+ _rng.randf_range(-3.0, 3.0)
	get_tree().root.get_child(0).add_child(bullet)

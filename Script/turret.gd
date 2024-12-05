extends StaticBody2D

enum TurretTypeEnum {
	BULLET,
	LASER,
}

@export var turretType: TurretTypeEnum
@export var bulletScene: PackedScene
@export var explosionScene: PackedScene
@export var fireRate: float
@export var shotDuration: float
@export var shotDelay := [0.0, 0.0]
@export var shootAngleVariation: float

var health := 3

var _rng := RandomNumberGenerator.new()

var _fire: bool = false
var _bullet
var _shoot_state: int = 1

@onready var player: RigidBody2D = $"../Player"
@onready var gun: Node2D = $Gun
@onready var bullet_spawner: Marker2D = $"Gun/Bullet Spawner"
@onready var shot_controller: Timer = $"Shot Controller"
@onready var fire_rate = $"Fire Rate"

func _ready():
	_rng.randomize()
	shot_controller.start()
	fire_rate.wait_time = fireRate
	
	if turretType == TurretTypeEnum.BULLET:
		shot_controller.connect("timeout", _on_shot_controller_timeout)


func _process(delta):
	var directionToPlayer: Vector2 = global_position.direction_to(
			player.global_position)
	var gunRotation: float = atan2(directionToPlayer.y, directionToPlayer.x)
	
	# rotate the gun to face player and limit the rotation value
	match turretType:
		TurretTypeEnum.BULLET:
			gun.global_rotation = gunRotation
		TurretTypeEnum.LASER:
			gun.global_rotation = lerp_angle(gun.global_rotation, gunRotation,
					1.0 / (1.0 - 0.7) * delta)
	
	gun.rotation_degrees = clampf(gun.rotation_degrees, -180.0, 0.0)
	
	if health <= 0:
		var explosion: CPUParticles2D = explosionScene.instantiate()
		explosion.global_position = global_position
		get_tree().root.get_child(0).add_child(explosion)
		explosion.restart()
		
		$"../Player Camera".shakeMultiplier = 0.5
		
		queue_free()


func _on_fire_rate_timeout():
	match turretType:
		TurretTypeEnum.BULLET:
			ShootBullet()
		TurretTypeEnum.LASER:
			Shoot()
			fire_rate.wait_time = _rng.randf_range(shotDelay[0], shotDelay[1])


func _on_shot_controller_timeout():
	match _shoot_state:
		1:
			_fire = true
			shot_controller.wait_time = shotDuration
		-1:
			_fire = false
			shot_controller.wait_time = _rng.randf_range(shotDelay[0], shotDelay[1])
	
	_shoot_state *= -1
	shot_controller.start()


func ShootBullet():
	var distanceToPlayer = global_position.distance_to(player.global_position)
	
	if _fire and distanceToPlayer < 300.0:
		Shoot()


func Shoot():
	_bullet = bulletScene.instantiate()
	
	_bullet.global_position = bullet_spawner.global_position
	_bullet.global_rotation = bullet_spawner.global_rotation + \
			deg_to_rad(_rng.randf_range(-shootAngleVariation,
			shootAngleVariation))
	
	get_parent().add_child(_bullet)

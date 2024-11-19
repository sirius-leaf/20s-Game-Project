extends StaticBody2D

enum TurretTypeEnum {
	BULLET,
	LASER,
}

@export var turretType: TurretTypeEnum
@export var bulletScene: PackedScene
@export var fireRate: float
@export var shotDuration: float
@export var shotDelay: float
@export var shootAngleVariation: float

var _rng := RandomNumberGenerator.new()

var _fire: bool = false
var _bullet: Area2D
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
	var gunRotation: float = clampf(atan2(directionToPlayer.y,
			directionToPlayer.x), -PI, 0.0)
	
	# rotate the gun to face player and limit the rotation value
	match turretType:
		TurretTypeEnum.BULLET:
			gun.rotation = gunRotation
		TurretTypeEnum.LASER:
			gun.rotation = lerp_angle(gun.rotation, gunRotation, 1.0 / (1.0 - 0.7) * delta)
	


func _on_fire_rate_timeout():
	match turretType:
		TurretTypeEnum.BULLET:
			ShootBullet()
		TurretTypeEnum.LASER:
			Shoot()


func _on_shot_controller_timeout():
	match _shoot_state:
		1:
			_fire = true
			shot_controller.wait_time = shotDuration
		-1:
			_fire = false
			shot_controller.wait_time = shotDelay
	
	_shoot_state *= -1
	shot_controller.start()


func ShootBullet():
	if _fire:
		Shoot()


func Shoot():
	_bullet = bulletScene.instantiate()
	
	_bullet.global_position = bullet_spawner.global_position
	_bullet.global_rotation = bullet_spawner.global_rotation + \
			deg_to_rad(_rng.randf_range(-shootAngleVariation,
			shootAngleVariation))
	
	get_parent().add_child(_bullet)

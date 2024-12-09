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
@export var baseSfxPitch: float

var health := 3

var _rng := RandomNumberGenerator.new()

var _fire: bool = false
var _bullet
var _shoot_state: int = 1
var _shotDelayMod: float

@onready var player: RigidBody2D = $"../Player"
@onready var gun: Node2D = $Gun
@onready var bullet_spawner: Marker2D = $"Gun/Bullet Spawner"
@onready var shot_controller: Timer = $"Shot Controller"
@onready var fire_rate = $"Fire Rate"
@onready var laser: AudioStreamPlayer2D = $LaserSFX
@onready var global_setting: GlobalSetting = $"../GlobalSetting"

func _ready():
	
	_rng.randomize()
	shot_controller.start()
	fire_rate.wait_time = fireRate
	
	if turretType == TurretTypeEnum.BULLET:
		_shotDelayMod = 1.0 if GlobalSet.ChaosMode else 0.0
		shot_controller.connect("timeout", _on_shot_controller_timeout)
	else:
		_shotDelayMod = 0.5 if GlobalSet.ChaosMode else 0.0


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
		get_tree().root.get_child(1).add_child(explosion)
		
		$"../Player Camera".shakeMultiplier = 0.5
		
		queue_free()


func _on_fire_rate_timeout():
	match turretType:
		TurretTypeEnum.BULLET:
			ShootBullet()
		TurretTypeEnum.LASER:
			var distanceToPlayer = global_position.distance_to(player.global_position)
			
			if distanceToPlayer < 300.0:
				Shoot()
				fire_rate.wait_time = _rng.randf_range(shotDelay[0] - _shotDelayMod,
						shotDelay[1] - _shotDelayMod)


func _on_shot_controller_timeout():
	match _shoot_state:
		1:
			_fire = true
			shot_controller.wait_time = shotDuration
		-1:
			_fire = false
			shot_controller.wait_time = _rng.randf_range(shotDelay[0] - \
					_shotDelayMod, shotDelay[1] - _shotDelayMod)
	
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
	
	get_tree().root.get_child(1).add_child(_bullet)
	
	laser.pitch_scale = _rng.randf_range(baseSfxPitch - 0.1, baseSfxPitch + 0.1)
	laser.play()

extends StaticBody2D

@export var bulletScene: PackedScene

var _rng := RandomNumberGenerator.new()

var _fire: bool = false
var _bullet: Area2D
var _shoot_state: int = 1

@onready var _player: RigidBody2D = $"../Player"
@onready var _gun: Node2D = $Gun
@onready var _bullet_spawner: Marker2D = $"Gun/Bullet Spawner"
@onready var _shot_controller: Timer = $"Shot Controller"

func _ready():
	_rng.randomize()
	_shot_controller.start()


func _process(delta):
	var directionToPlayer: Vector2 = global_position.direction_to(
			_player.global_position)
	
	# rotate the gun to face player and limit the rotation value
	_gun.rotation = clampf(atan2(directionToPlayer.y, directionToPlayer.x),
			-PI, 0.0)
	


func _on_fire_rate_timeout():
	if _fire:
		_bullet = bulletScene.instantiate()
		
		_bullet.global_position = _bullet_spawner.global_position
		_bullet.global_rotation = _bullet_spawner.global_rotation + \
				deg_to_rad(_rng.randf_range(-3, 3))
		
		get_parent().add_child(_bullet)


func _on_shot_controller_timeout():
	match _shoot_state:
		1:
			_fire = true
			_shot_controller.wait_time = 1.0
		-1:
			_fire = false
			_shot_controller.wait_time = 2.0
	
	_shoot_state *= -1
	_shot_controller.start()

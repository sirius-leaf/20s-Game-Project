extends Marker2D

@export var flyingEnemy: Array[PackedScene]
@export var turretSpawner: PackedScene
@export var building: Array[PackedScene]
@export var powerSource: PackedScene

var _rng := RandomNumberGenerator.new()
var _object
var _powerSourceSpawnPos := 1000.0

@onready var player: RigidBody2D = $"../Player"

func _process(delta):
	if global_position.x - player.global_position.x < 350.0:
		build()


func build():
	var spawnType := _rng.randi_range(1, 6)
	var moveOffset := 0.0
	
	spawnType = 0 if global_position.x >= _powerSourceSpawnPos else spawnType
	
	if spawnType == 0:
		_object = powerSource.instantiate()
		
		_object.global_position = global_position
		_powerSourceSpawnPos += 1000.0
	elif spawnType <= 1:
		# spawn flying enemy
		_object = flyingEnemy[_rng.randi_range(0, flyingEnemy.size() -
				1)].instantiate()
		
		_object.global_position = Vector2(global_position.x,
				global_position.y - _rng.randf_range(50.0, 400.0))
	elif spawnType <= 3:
		# spawn buildings
		_object = building[_rng.randi_range(0, building.size() - 1)].instantiate()
		
		_object.global_position = Vector2(global_position.x,
				global_position.y + _rng.randf_range(0.0, 90.0))
		
		moveOffset = _object.get_node("BuildingLength").position.x if \
				_object.has_node("BuildingLength") else 0.0
	else:
		# spawn turrets
		_object = turretSpawner.instantiate()
		
		_object.global_position = global_position
	
	get_tree().root.get_child(0).add_child(_object)
	
	global_position.x += 70 + moveOffset + _rng.randf_range(0.0, 250.0)

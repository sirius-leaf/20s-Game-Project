extends Marker2D

@export var flyingEnemy: Array[PackedScene]
@export var turretSpawner: PackedScene
@export var building: Array[PackedScene]
@export var powerSource: PackedScene
@export var targetBuilding: PackedScene

var _rng := RandomNumberGenerator.new()
var _object
var _powerSourceSpawnPos := 1000.0
var _powerSourceAmount := 0
var _build := true
var _objectSpawnOffset: float

@onready var player: Player_ = $"../Player"
@onready var global_setting: GlobalSetting = $"../GlobalSetting"

func _ready() -> void:
	_objectSpawnOffset = 150.0 if global_setting.ChaosMode else 250.0


func _process(delta):
	if global_position.x - player.position.x < 350.0 and _build:
		build()


func build():
	var spawnType := _rng.randi_range(1, 8)
	var moveOffset := 0.0
	
	if global_position.x >= _powerSourceSpawnPos:
		spawnType = 0
		
		if _powerSourceAmount >= 3:
			spawnType = -1
	
	if spawnType == 0:
		# spawn power source
		_object = powerSource.instantiate()
		
		_object.global_position = global_position
		_powerSourceSpawnPos += 1000.0
		_powerSourceAmount += 1
	elif spawnType == -1:
		# spawn target building
		_object = targetBuilding.instantiate()
		
		_object.global_position = global_position
		_build = false
	elif spawnType <= 2:
		# spawn flying enemy
		_object = flyingEnemy[_rng.randi_range(0, flyingEnemy.size() -
				1)].instantiate()
		
		_object.global_position = Vector2(global_position.x,
				global_position.y - _rng.randf_range(50.0, 400.0))
	elif spawnType <= 5:
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
	
	get_tree().root.get_child(1).add_child(_object)
	
	global_position.x += 70 + moveOffset + _rng.randf_range(0.0, _objectSpawnOffset)

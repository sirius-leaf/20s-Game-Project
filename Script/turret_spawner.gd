extends Marker2D

@export var turretScene: Array[PackedScene]

var _rng := RandomNumberGenerator.new()

func _ready():
	_rng.randomize()
	
	var turret = turretScene[_rng.randi_range(0, turretScene.size() - 
			1)].instantiate()
	
	turret.global_position = global_position
	
	get_tree().root.get_child(1).add_child(turret)
	queue_free()

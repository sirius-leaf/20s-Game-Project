extends Marker2D

@export var blockScene: PackedScene

var _rng := RandomNumberGenerator.new()
var _blockScale: float

func _ready():
	_rng.randomize()


func _process(delta):
	var player: RigidBody2D = $"../Player"
	
	# spawn and move the spawner when player is close
	if global_position.x - player.global_position.x < 450.0:
		_blockScale = _rng.randf_range(0.25, 2.0)
		spawn_block()
		position.x += 150
		position.y = player.position.y + _rng.randf_range(-300.0, 300.0)


func spawn_block():
	var block := blockScene.instantiate()
	get_tree().root.add_child(block)
	block.position = position

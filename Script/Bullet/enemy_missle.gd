extends "res://Script/Bullet/bullet.gd"

@export var explosionParticle: PackedScene
@export var rotateSpeed: float

var _queue: Array
var _trailLength := 10

@onready var player: RigidBody2D = $"../Player"
@onready var direction_guide: Node2D = $"Direction Guide"
@onready var trail: Line2D = $Trail
@onready var trail_origin: Marker2D = $TrailOrigin

func _process(delta):
	var trailOrigin := trail_origin.global_position
	
	_queue.push_front(trailOrigin)
	direction_guide.look_at(player.global_position)
	
	if _queue.size() > _trailLength:
		_queue.pop_back()
	
	trail.clear_points()
	
	for point in _queue:
		trail.add_point(point)
	
	if direction_guide.rotation > 0:
		rotate(rotateSpeed * delta)
	else:
		rotate(-rotateSpeed * delta)


func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.healthValue -= 4
		$"../Player Camera".shakeMultiplier = 0.7
	
	spawn_explosion_particle()
	queue_free()


func _on_life_time_timeout():
	spawn_explosion_particle()
	queue_free()


func spawn_explosion_particle():
	var particle: CPUParticles2D = explosionParticle.instantiate()
	particle.global_position = global_position
	get_tree().root.get_child(1).add_child(particle)

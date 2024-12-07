extends "res://Script/Bullet/bullet.gd"

@export var smallShockwaveScene: PackedScene

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

func _ready():
	cpu_particles_2d.restart()
	spawn_small_particle()

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.healthValue -= 5


func spawn_small_particle():
	var smallShockwave: CPUParticles2D = smallShockwaveScene.instantiate()
	smallShockwave.global_position = global_position
	get_tree().root.get_child(0).add_child(smallShockwave)

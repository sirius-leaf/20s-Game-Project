extends "res://Script/Bullet/bullet.gd"

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

func _ready():
	cpu_particles_2d.restart()

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.healthValue -= 5

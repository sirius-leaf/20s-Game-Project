extends StaticBody2D

@onready var laser: Line2D = $Line2D
@onready var player_camera: Camera = $"../Player Camera"
@onready var defense: Area2D = $Defense
@onready var player: Player = $"../Player"
@onready var big_laser: AudioStreamPlayer = $Defense/BigLaser

func _process(delta: float) -> void:
	if player.powerSourceDestroyed >= 3:
		defense.monitoring = false


func _physics_process(delta: float) -> void:
	laser.width = lerp(laser.width, 0.0, 0.1)


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		body.insideTarget = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.insideTarget = false


func _on_defense_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		laser.width = 64.0
		player_camera.shakeMultiplier = 2.0
		big_laser.play()
		body.healthValue = 0

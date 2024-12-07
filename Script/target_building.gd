extends StaticBody2D


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		body.insideTarget = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.insideTarget = false

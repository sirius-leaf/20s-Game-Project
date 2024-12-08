extends RigidBody2D

@onready var glow: Sprite2D = $Glow
@onready var global_setting: GlobalSetting = $"../GlobalSetting"

func _physics_process(delta: float) -> void:
	var expandSpeed: float = 12.0
	if global_setting.timeEnd:
		glow.visible = true
		glow.scale += Vector2(expandSpeed, expandSpeed) * delta


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Target"):
		freeze = true

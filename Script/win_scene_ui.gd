extends Control

@export var levelScene: PackedScene
@export var mainMenuScene: PackedScene

@onready var mission_label: Label = $MissionLabel
@onready var status_label: Label = $StatusLabel
@onready var transition: TextureRect = $Transition

func _ready() -> void:
	mission_label.text = "mission success" if GlobalSet.playerIsWin else "mission failed"
	status_label.text = "The enemy base has been destroyed" if GlobalSet.playerIsWin else "The bomb did not reach its target"


func _process(delta: float) -> void:
	transition.modulate.a = clamp(transition.modulate.a - 1.0 * delta, 0.0, 1.0) if transition.modulate.a > 0.0 else 0.0


func _on_play_button_button_down() -> void:
	get_tree().change_scene_to_packed(levelScene)


func _on_menu_button_button_down() -> void:
	get_tree().change_scene_to_packed(mainMenuScene)

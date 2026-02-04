extends Control
var time: float

func _physics_process(delta: float) -> void:
	$ColorRect.color = Color.from_hsv(time / 10, 1, 1)
	time += delta

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://test_world.tscn")

extends Control
var time: float

func _physics_process(delta: float) -> void:
	$ColorRect.color = Color.from_hsv(time / 10, 1, 1)
	time += delta



func _on_start_pressed() -> void:
	Global.root.loadScene("res://Test/test_world.tscn")


func _on_shittins_pressed() -> void:
	Global.root.loadScene("res://settings.tscn")

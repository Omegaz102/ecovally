extends Node3D

func _ready() -> void:
	$Timer.start()

func _physics_process(delta: float) -> void:
	scale.x = $Timer.time_left/$Timer.wait_time
	scale.z = $Timer.time_left/$Timer.wait_time



func _on_timer_timeout() -> void:
	queue_free()

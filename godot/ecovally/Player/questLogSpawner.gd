extends Control

const questLog:PackedScene = preload("res://UI/QuestLog/questLog.tscn")
var logInstence:Node

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("openLog"):
		if logInstence:
			print("closed")
			logInstence.queue_free()
			logInstence = null
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			print("opened")
			logInstence = questLog.instantiate()
			add_child(logInstence)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			

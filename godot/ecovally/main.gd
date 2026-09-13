extends Node
class_name Main
var currentScene: Node

func _ready() -> void:
	Global.root = self
	loadScene("res://UI/MainMenu.tscn")

func loadScene(pathToScene: String):
	if currentScene:
		currentScene.queue_free()
	currentScene = load(pathToScene).instantiate()
	add_child(currentScene)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

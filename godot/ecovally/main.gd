extends Node
var currentScene: Node
var player: Node
var hotBar: Node

func _ready() -> void:
	loadScene("res://test_world.tscn")

func loadScene(pathToScene: String):
	if currentScene != null:
		currentScene.queue_free()
	var newScene: PackedScene = load(pathToScene)
	currentScene = newScene.instantiate()
	add_child(currentScene)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

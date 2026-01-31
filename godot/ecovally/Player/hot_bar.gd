extends Node3D

var selected: String = "first"
var hotBar: Array = []
var size = 3

func addItem(Item: Node):
	var equiped = false
	for i in hotBar:
		if hotBar[i] == null:
			equiped = true
			hotBar[i] = Item
	if equiped == false:
		pass
		
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("NextItem"):
		if selected == "first":
			selected = "second"
	if Input.is_action_just_pressed("NextItem"):
		if selected == "second":
			selected = "third"
	if Input.is_action_just_pressed("NextItem"):
		if selected == "third":
			selected = "first"

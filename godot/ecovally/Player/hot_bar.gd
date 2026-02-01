extends Node3D

var selected: int = 1
var hotBar: Array = []
var size = 3


func _ready() -> void:
	Global.hotBar = self
	hotBar.resize(size)

func addItem(Item: Node):
	var equiped = false
	for i in hotBar.size() - 1:
		if hotBar[i] == null:
			equiped = true
			hotBar[i] = Item
			print(hotBar[i])
			break
	if equiped == false:
		pass
	print(hotBar)
		
func changeItem(item: Node):
	if get_child_count() != 0:
		remove_child(get_child(0))
	add_child(item)
		
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("NextItem"):
		selected += 1
		if selected > hotBar.size() - 1:
			selected = 0
		if hotBar[selected] != null:
			changeItem(hotBar[selected])
		else:
			if get_child_count() > 0:
				remove_child(get_child(0))
			
	if Input.is_action_just_pressed("PreviousItem"):
		selected -= 1
		if selected < 0:
			selected = hotBar.size() - 1
		if hotBar[selected] != null:
			changeItem(hotBar[selected])
		else:
			if get_child_count() > 0:
				remove_child(get_child(0))
	%DevLable.text = str(selected)

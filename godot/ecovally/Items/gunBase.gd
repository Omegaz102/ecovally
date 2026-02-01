extends "res://Interactable.gd"


func _on_interacted() -> void:
	Global.hotBar.addItem(self)
	position = Vector3()
	rotation = Vector3()
	scale = Vector3(1, 1, 1)
	get_parent().remove_child(self)


func _on_tree_entered() -> void:
	if get_parent() == Global.hotBar:
		var equiped = true
		$CollisionShape3D.disabled = true
	else:
		$CollisionShape3D.disabled = false


func _on_tree_exited() -> void:
	var equiped = false

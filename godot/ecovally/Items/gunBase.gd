extends "res://Interactable.gd"


func _on_interacted() -> void:
	pass # Replace with function body.


func _on_tree_entered() -> void:
	if get_parent() == %hotBar:
		var equiped = true
		$CollisionShape3D.disabled = true
	else:
		$CollisionShape3D.disabled = false


func _on_tree_exited() -> void:
	var equiped = false

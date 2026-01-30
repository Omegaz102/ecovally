extends RayCast3D

func _physics_process(delta: float) -> void:
	if is_colliding():
		var collider = get_collider()
		if collider is Interactable and collider is Node:
			%DevLable.text = collider.DisplayName
		else:
			%DevLable.text = ""

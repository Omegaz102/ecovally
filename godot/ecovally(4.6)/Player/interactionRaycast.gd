extends RayCast3D

func _physics_process(delta: float) -> void:
	if is_colliding():
		var collider = get_collider()
		if collider is Interactable and collider is Node:
			#%DevLable.text = collider.DisplayName
			if Input.is_action_just_pressed("interact"):
				collider.SendSignal()
		else:
			#%DevLable.text = ""
			pass

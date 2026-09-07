extends RayCast3D

func _physics_process(delta: float) -> void:
	if is_colliding():
		var collider = get_collider()
		if Input.is_action_just_pressed("interact") and collider.has_method("interact"):
			collider.interact()
		else:
			#%DevLable.text = ""
			pass

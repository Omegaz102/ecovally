extends CollisionObject3D
class_name Interactable
 
signal Interacted()
@export var DisplayName = "[INTERACTABLE]"

func interact():
	emit_signal("Interacted")

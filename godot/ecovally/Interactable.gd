extends StaticBody3D

class_name Interactable
 
signal Interacted()
@export var DisplayName = "[INTERACTABLE]"

func SendSignal():
	emit_signal("Interacted")

extends Interactable

var spinning = false
func _on_interacted() -> void:
	if spinning == false:
		spinning = true
		%testNPC.speechQueue["spined"] = "wowzers, you're good at spining that thing"
	else:
		spinning = false
	
func _physics_process(delta: float) -> void:
	rotate_y(int(spinning) * 4 * delta)

extends Button
class_name QuestIndex

var Title:String
var Description:String

signal selected(title:String, description:String)

func _physics_process(delta: float) -> void:
	await button_up
	emit_signal("selected", Title, Description)
	print("emited: " + Title)

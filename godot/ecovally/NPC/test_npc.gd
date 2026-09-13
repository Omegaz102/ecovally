extends NPC

func _ready() -> void:
	Global.testNPC = self
	Global.questMan.startQuest.call_deferred("res://Quests/spinTheCube.gd")

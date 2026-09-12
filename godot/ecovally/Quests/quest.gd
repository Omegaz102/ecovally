extends Node

var title:String = "Untitled Quest"
var description:String = "the description for the quest has yet to be set"
var visable:bool = true

func _ready() -> void:
	Global.questMan.activeQuests[name] = self

func complete():
	Global.questMan.activeQuests.erase(name)
	Global.questMan.completedQuests.append(name)
	queue_free()

func sayAwait(npc:NPC, text):
	npc.say(text)
	while true:
		var key = NPC.spoke
	

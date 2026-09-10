class_name NPC
extends CharacterBody3D

signal Interacted()
@export var DisplayName = "[NPC]"
@export var idleText:Array = ["sup", ["hello", "this is a test"]]
var speachQueue:Dictionary = {"funFact":"Fun fact, you can interact with the cube to my left. Give it a spin and come back to me when you're done.", "arrayTest":["this is an array test", "this dialogue can be ignored", "each line is it's own index in an array wich is being passed to the say function"]}

signal spoke(textID)

func interact():
	emit_signal("Interacted")
	if speachQueue.size() == 0:
		say(idleText.pick_random())
	else:
		say(speachQueue.values()[0])
		emit_signal("spoke", speachQueue.keys()[0])
		print(speachQueue.erase(speachQueue.keys()[0]))
	
func say(text):
	if text is String:
		Global.textBox.say(text)
	elif text is Array:
		for i in text:
			say(i)

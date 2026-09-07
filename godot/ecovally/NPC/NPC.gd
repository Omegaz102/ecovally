class_name NPC
extends CharacterBody3D

signal Interacted()
@export var DisplayName = "[NPC]"

func interact():
	emit_signal("Interacted")
	say("hello")
	
func say(text):
	print(text)
	Global.textBox.say(text)

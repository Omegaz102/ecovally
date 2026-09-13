extends Quest

func _ready() -> void:
	title = "spin the cube"
	description = "These wierdo just told you to spin a cube"
	sayAwait(Global.testNPC,
	"spintCubeIntro",
	["hey dude",
	 "can you do me a favor",
	 "you see that cube over there",
	 "walk over there and interact with it"])
	
	await Global.spinCube.Interacted
	
	sayAwait(Global.testNPC,
	"spiningCubeJizz",
	["*cums*",
	"thanks man",
	"that was by far the most fruitiger aero cube I've ever seen",
	"It's like the past or somthing"])

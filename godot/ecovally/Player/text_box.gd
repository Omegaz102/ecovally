extends Control

@onready var display: RichTextLabel = $RichTextLabel
@onready var backdrop: AnimatedSprite2D = $AnimatedSprite2D
var queue: Array
const MAX_CHARACTERS: int = 150

func _ready() -> void:
	display.visible = false
	backdrop.visible = false
	Global.textBox = self

func _physics_process(_delta: float) -> void:
	if queue.size() > 0:
		display.text = queue[0]
		display.visible=true
		backdrop.visible=true
		if Input.is_action_just_pressed("shoot"):
			queue.remove_at(0)
			if queue.size() == 0:
				display.visible = false
				backdrop.visible = false

func say(text):
	var pieceOfText: String
	var words: Array = text.split(" ")
	var i: int = 0
	for n in words:
		i += 1
		if pieceOfText.length() + n.length() + 1 > MAX_CHARACTERS:
			output(pieceOfText) 
			pieceOfText = n
		else:
			pieceOfText += " " + n
		if i == words.size():
			output(pieceOfText)
	
func output(text:String):
	queue.append(text)

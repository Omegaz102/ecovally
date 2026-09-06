extends Control

@onready var display: RichTextLabel = $RichTextLabel
@onready var backdrop: ColorRect = $ColorRect
var queue: Array
const MAX_CHARACTERS: int = 150

func _ready() -> void:
	display.visible=false
	backdrop.visible=false

func _physics_process(delta: float) -> void:
	if queue.size() > 0:
		display.text = queue[0]
		display.visible=true
		backdrop.visible=true
		if Input.is_action_just_pressed("shoot"):
			queue.remove_at(0)
			if queue.size() == 0:
				display.visible = false
				backdrop.visible = false
				
	if Input.is_key_pressed(KEY_F1):
		say("Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.")

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

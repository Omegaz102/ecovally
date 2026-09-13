extends CenterContainer

@onready var questTitle:Label = $HBoxContainer/PanelContainer/VBoxContainer/MarginContainer/Title
@onready var questDescription = $HBoxContainer/PanelContainer/VBoxContainer/MarginContainer2/Description

func _ready() -> void:
	questDescription.text = ""
	questTitle.text = ""
	var questItemScene:PackedScene = preload("res://UI/QuestLog/questItem.tscn")
	var quests:Array = Global.questMan.get_children()
	for quest in quests:
		if quest is Quest:
			var newQuestIndex:QuestIndex = questItemScene.instantiate()
			newQuestIndex.name = quest.name
			newQuestIndex.text = quest.title
			newQuestIndex.Title = quest.title
			newQuestIndex.Description = quest.description
			newQuestIndex.connect("selected", _display_quest)
			$HBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer.add_child(newQuestIndex)
			
func _display_quest(title:String, description:String):
	print("selected")
	print(title)
	questTitle.text = title
	questDescription.text = description

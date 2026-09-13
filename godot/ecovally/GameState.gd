extends Node

var chapter_id: String = "chapter_1"
var dialogue_index: int = 0
var choices_made: Array[String] = []

#Default values for reset
const Defaults: Dictionary = {
	"chapter_id": "chapter_1",
	"dialogue_index": 0,
}

func reset() -> void:
	chapter_id = Defaults["chapter_id"]
	dialogue_index = 0
	choices_made = []

func to_dict() -> Dictionary:
	return {
		"save_version": 1,
		"chapter_id": chapter_id,
		"dialogue_index": dialogue_index,
		"choices_made": choices_made,
		"timestamp": Time.get_datetime_string_from_system(),
	}

func from_dict(data: Dictionary) -> void:
	chapter_id = data.get("chapter_id", Defaults["chapter_id"])
	dialogue_index = data.get("dialogue_index", 0)
	choices_made.assign(data.get("choices_made", []))
	

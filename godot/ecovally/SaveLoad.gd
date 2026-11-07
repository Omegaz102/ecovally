extends Node

const saveLocation = "user://SaveFile.json"

var saveContents: Dictionary = {
	"progressBarValue": 0.0,
	"new_data_to_save": false
}

func _ready() -> void:
	_load()

func _save() -> void:
	var file := FileAccess.open(saveLocation, FileAccess.WRITE)
	if file == null:
		push_error("Could not open save file: %s" % FileAccess.get_open_error())
		return
	file.store_string(JSON.stringify(saveContents, "\t"))
	file.close()

func _load() -> void:
	if not FileAccess.file_exists(saveLocation):
		return

	var file := FileAccess.open(saveLocation, FileAccess.READ)
	if file == null:
		push_error("Could not open save file: %s" % FileAccess.get_open_error())
		return
	var text := file.get_as_text()
	file.close()

	var json := JSON.new()
	if json.parse(text) != OK:
		push_error("Save file is corrupt (line %d): %s" % [json.get_error_line(), json.get_error_message()])
		return
	if not json.data is Dictionary:
		push_error("Save file has unexpected format.")
		return

	var saveData: Dictionary = json.data
	# .get() with a default keeps old/partial saves from crashing the game
	saveContents.progressBarValue = float(saveData.get("progressBarValue", 0.0))
	saveContents.new_data_to_save = bool(saveData.get("new_data_to_save", false))

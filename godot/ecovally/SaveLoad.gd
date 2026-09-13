extends Node

const saveLocation = "user://SaveFile.json"

var saveContents: Dictionary = {
	"progressBarVaulue": 0.0,
	"new_data_to_save": false
	
}

func _ready() -> void:
	_load()

func _save():
	var file = FileAccess.open(saveLocation, FileAccess.WRITE)
	file.store_var(saveContents.duplicate())
	file.close()

func _load():
	if FileAccess.file_exists(saveLocation):
		var file = FileAccess.open(saveLocation, FileAccess.READ)
		var data = file.get_var()
		
		var saveData = data.duplicate()
		saveContents.progressBarValue = saveData.progressBarValue
		saveContents.new_data_to_save = saveData.new_data_to_save

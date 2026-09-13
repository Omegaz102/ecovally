extends Node

signal game_save(slot: int)
signal game_loaded(slot:int)

func _on_save_pressed(slot_index) -> void:
	SaveManager.SaveGame(slot_index)

func saveGame(slot: int) -> void:
	var data := {
		"version": 1,
		"playerPosition": player.gloabl_position,
		"playerHealth": player.health,
		"currentScene": get_tree().current_scene.scene_file_path,
		"inventory": serialize_inventory(),
}

func loadGame(slot: int) -> bool:

extends Control

@export var you_escaped_the_tower: String = "res://You escaped the tower.tscn"

func _on_button_pressed():
	GameManager.key_found.clear()
	GameManager.opened_doors.clear()
	GameManager.visited.clear()
	
	get_tree().change_scene_to_file(you_escaped_the_tower)

func _on_play_again_pressed() -> void:
	if GameManager.player_health == 0:
		SoundManager.play_music("main_music")

	GameManager.score = 0
	GameManager.player_health = GameManager.max_health
	get_tree().change_scene_to_file("res://USETHISTILEMAP.tscn")

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")

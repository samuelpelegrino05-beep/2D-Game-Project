extends Control

@export var you_escaped_the_tower: String = "res://You escaped the tower.tscn"

func _on_button_pressed():
	GameManager.key_found.clear()
	GameManager.opened_doors.clear()
	GameManager.visited.clear()
	
	get_tree().change_scene_to_file(you_escaped_the_tower)

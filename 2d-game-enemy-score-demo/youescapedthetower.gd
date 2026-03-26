extends Control

@export var next_scene: String = "res://youescapedthetower.gd"

func _on_button_pressed():
	GameManager.key_found.clear()
	GameManager.opened_doors.clear()
	GameManager.visited.clear()
	
	# Reload the game
	get_tree().change_scene_to_file(next_scene)

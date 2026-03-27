extends Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS  # Menu still processes when game is paused

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://USETHISTILEMAP.tscn")

extends Node2D
@onready var settings_button = $Settings

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS  # Menu still processes when game is paused

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://instructions.tscn")

func _on_settings_pressed() -> void:
	var submenu = load("res://settings.tscn").instantiate()
	submenu.process_mode = Node.PROCESS_MODE_ALWAYS
	submenu.return_to = null  # no pause menu exists
	get_tree().root.add_child(submenu)
	# Do NOT hide anything, keep it fully visible
	hide()  # hide main menu

func _on_quit_pressed() -> void:
	get_tree().quit()

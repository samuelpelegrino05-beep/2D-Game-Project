# PauseMenu.gd
extends Control

# ===== Nodes =====
@onready var animation_player = $AnimationPlayer

# ===== Setup =====
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS  # menu still processes while paused
	animation_player.process_mode = Node.PROCESS_MODE_ALWAYS  # blur animation runs while paused
	hide()
	animation_player.play("RESET")

# ===== Pause / Resume =====
func pause():
	get_tree().paused = true
	show()
	animation_player.play("blur")

func resume():
	animation_player.play_backwards("blur")
	await animation_player.animation_finished
	get_tree().paused = false
	hide()

# Called by submenus to show pause menu again
func show_pause_menu():
	show()

# ===== Input handling =====
func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		if not is_visible():  # only toggle pause if menu is hidden
			if get_tree().paused:
				resume()
			else:
				pause()

# ===== Button callbacks =====
func _on_resume_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	animation_player.play_backwards("blur")
	await animation_player.animation_finished
	
	if GameManager.player_health == 0:
		SoundManager.play_music("main_music")

	GameManager.score = 0
	GameManager.player_health = GameManager.max_health

	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
	if GameManager.player_health == 0:
		SoundManager.play_music("main_music")

func _on_settings_pressed() -> void:
	open_submenu("res://settings.tscn")

func _on_input_settings_pressed() -> void:
	open_submenu("res://input_settings.tscn")

func _on_sound_settings_pressed() -> void:
	open_submenu("res://volume_controls.tscn")

# ===== Helper to open submenus =====
func open_submenu(path: String) -> void:
	var submenu_scene = load(path)  # load() works with variables
	var submenu = submenu_scene.instantiate()
	submenu.process_mode = Node.PROCESS_MODE_ALWAYS  # works while paused
	get_parent().add_child(submenu)
	submenu.return_to = self  # pause menu reference
	hide()

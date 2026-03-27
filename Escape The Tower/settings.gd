extends Control

enum Origin { MAIN_MENU, PAUSE_MENU }

# Track where we came from
var origin: Origin
var return_to: Node = null  # reference to pause menu

@onready var exit_button = $ExitButton

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_controls_pressed():
	var input_menu = preload("res://input_settings.tscn").instantiate()
	input_menu.return_to = self
	get_parent().add_child(input_menu)
	hide()  # hide settings while input menu is open

func _on_sound_pressed():
	var volume_menu = preload("res://volume_controls.tscn").instantiate()
	volume_menu.return_to = self
	get_parent().add_child(volume_menu)
	hide()  # hide settings while volume menu is open

func on_exit_pressed():
	match origin:
		Origin.MAIN_MENU:
			get_tree().change_scene_to_file("res://main_menu.tscn")
		Origin.PAUSE_MENU:
			if return_to:
				return_to.show()
			get_tree().paused = true
	queue_free()
	
func _unhandled_input(event):
	if event.is_action_pressed("Pause") && get_tree().paused == true:
		hide()
		if return_to and return_to.has_method("show_pause_menu"):
			return_to.show_pause_menu()

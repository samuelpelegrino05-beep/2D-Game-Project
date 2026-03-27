# VolumeMenu.gd
extends Control

# Reference back to the Settings menu
var return_to: Node

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func on_exit_pressed():
	if return_to:
		return_to.show()
	queue_free()

func _unhandled_input(event):
	if event.is_action_pressed("Pause") && get_tree().paused == true:
		hide()
		if return_to and return_to.has_method("show_pause_menu"):
			return_to.show_pause_menu()

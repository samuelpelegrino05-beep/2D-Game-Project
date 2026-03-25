extends Button

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _pressed():
	var parent_node = find_parent("*")  # finds the first parent
	while parent_node:
		if parent_node.has_method("on_exit_pressed"):
			parent_node.on_exit_pressed()
			return
		parent_node = parent_node.get_parent()

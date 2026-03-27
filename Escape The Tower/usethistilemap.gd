extends Node2D

func _ready():
	# Enable Y-sorting on this node
	y_sort_enabled = true
	
	# Optional: ensure all children use same z_index
	for child in get_children():
		if child is Node2D:
			child.z_index = 0


func _on_damage_area_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

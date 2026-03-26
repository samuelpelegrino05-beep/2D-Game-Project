extends Node2D

@export var key_id: String

func _ready():
	if key_id in GameManager.key_found:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if key_id not in GameManager.key_found:
		GameManager.key_found.append(key_id)
	queue_free()

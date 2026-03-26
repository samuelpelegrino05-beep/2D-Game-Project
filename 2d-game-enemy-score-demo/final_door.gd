extends StaticBody2D

@export var door_id: String
@export var next_scene: String = "res://youescapedthetower.gd"

func _ready():
	if door_id in GameManager.opened_doors:
		queue_free()

func _on_area_2d_body_entered(_body):
	if door_id in GameManager.key_found:
		$AnimationPlayer.play("Open")
		GameManager.opened_doors.append(door_id)
		await $AnimationPlayer.animation_finished
		queue_free()
	else:
		$AnimationPlayer.play("Closed")
	

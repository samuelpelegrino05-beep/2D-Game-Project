extends StaticBody2D

@export var door_id: String
@export var you_escaped_the_tower: String

func _ready():
	if door_id in GameManager.opened_doors:
		queue_free()

func _on_area_2d_body_entered(_body):
	if door_id in GameManager.key_found:
		$AnimationPlayer.play("Open")
		GameManager.opened_doors.append(door_id)
		await $AnimationPlayer.animation_finished
		
		get_tree().change_scene_to_file(you_escaped_the_tower)
	else:
		$AnimationPlayer.play("Closed")
	

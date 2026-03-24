extends Node2D

var owner_body: CharacterBody2D  # player reference
@export var BulletScene = preload("res://Bullet.tscn")

func _physics_process(delta):
	if owner_body == null:
		return

	# Position wand relative to player
	position = Vector2(9, 5)  # basic offset
	# Rotate toward mouse
	look_at(get_global_mouse_position())

func shoot():
	var bullet = BulletScene.instantiate()
	bullet.global_position = global_position
	bullet.global_rotation = rotation
	get_tree().current_scene.add_child(bullet)
	# Prevent bullet from hitting player
	bullet.add_collision_exception_with(owner_body)

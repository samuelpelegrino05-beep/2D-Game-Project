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
	
	var direction = (get_global_mouse_position() - $Muzzle.global_position).normalized()
	
	bullet.global_position = $Muzzle.global_position
	bullet.velocity = direction * bullet.speed
	bullet.rotation = direction.angle()
	
	get_tree().current_scene.add_child(bullet)

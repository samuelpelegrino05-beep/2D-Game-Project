extends CharacterBody2D

var is_dead = false

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	if animated_sprite:
		animated_sprite.play("Idle")

func take_damage(amount: int):
	if is_dead:
		return

	is_dead = true
	die()

func die():
	# Play death animation
	if animated_sprite:
		animated_sprite.play("Death")

	# Wait for animation to finish
	await animated_sprite.animation_finished

	queue_free()

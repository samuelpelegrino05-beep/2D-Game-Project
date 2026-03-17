extends CharacterBody2D

@export var speed = 2000
@export var max_bounces = 6

var bounce_count = 0

func _ready():
	velocity = Vector2.RIGHT.rotated(global_rotation) * speed
	# assuming the player is the parent of the muzzle
	add_collision_exception_with(get_parent())

func _physics_process(delta):

	var collision = move_and_collide(velocity * delta)

	if collision:

		bounce_count += 1
		if bounce_count >= max_bounces:
			queue_free()
			return

		velocity = velocity.bounce(collision.get_normal())

		# rotate bullet to new direction
		rotation = velocity.angle()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

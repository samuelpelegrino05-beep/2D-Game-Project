extends CharacterBody2D

var pos: Vector2
var rota: float
var dir: float
var speed = 2000

func _ready():
	pos = global_position
	rota = global_rotation

func _physics_process(delta):
	velocity = Vector2(speed, 0).rotated(dir)
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit()
	
func _on_VisibilityNotifier2D_screen_exited():
	# Deletes the bullet when it exits the screen.
	queue_free()

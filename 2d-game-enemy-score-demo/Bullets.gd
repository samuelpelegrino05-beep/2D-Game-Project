extends CharacterBody2D

@export var speed = 1500
@export var max_bounces = 6
@export var damage = 10
@export var base_score = 100
@export var bounce_bonus = 50

var bounce_count = 0

func _ready():
	velocity = Vector2.RIGHT.rotated(global_rotation) * speed
	add_collision_exception_with(get_parent())

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)

	if collision:
		var body = collision.get_collider()

		# 💥 Deal damage if possible
		if body and body.has_method("take_damage"):
			body.take_damage(damage)
			award_score()
			queue_free()

		bounce_count += 1
		if bounce_count >= max_bounces:
			queue_free()
			return

		velocity = velocity.bounce(collision.get_normal())
		rotation = velocity.angle()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func award_score():
	var total_score = base_score + (bounce_count * bounce_bonus)
	GameManager.add_score(total_score)

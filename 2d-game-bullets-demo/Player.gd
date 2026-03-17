extends CharacterBody2D

@export var SPEED: float = 200.0
@export var DASH_SPEED: float = 400.0
@export var DASH_TIME: float = 0.15
@export var Bullet = preload("res://Bullet.tscn")

var dash_velocity = Vector2.ZERO
var dash_timer = 0.0
var is_moving = true

func _physics_process(delta):
	look_at(get_global_mouse_position())

	if Input.is_action_just_pressed("Fire"):
		shoot()

	if Input.is_action_just_pressed("Dash") and is_moving:
		start_dash()

	move_character(delta)
	move_and_slide()

func move_character(delta):
	if not is_moving:
		velocity = Vector2.ZERO
		return

	var direction = Vector2.ZERO
	if Input.is_action_pressed("Left"):
		direction.x -= 1
	if Input.is_action_pressed("Right"):
		direction.x += 1
	if Input.is_action_pressed("Up"):
		direction.y -= 1
	if Input.is_action_pressed("Down"):
		direction.y += 1

	if direction != Vector2.ZERO:
		direction = direction.normalized()

	# Base movement
	velocity = direction * SPEED

	# Add dash if active
	if dash_timer > 0:
		velocity += dash_velocity
		dash_timer -= delta
	else:
		dash_velocity = Vector2.ZERO

func start_dash():
	var direction = Vector2.ZERO
	if Input.is_action_pressed("Left"):
		direction.x -= 1
	if Input.is_action_pressed("Right"):
		direction.x += 1
	if Input.is_action_pressed("Up"):
		direction.y -= 1
	if Input.is_action_pressed("Down"):
		direction.y += 1

	if direction == Vector2.ZERO:
		# dash forward if no input
		direction = Vector2.RIGHT.rotated(rotation)

	dash_velocity = direction.normalized() * DASH_SPEED
	dash_timer = DASH_TIME

func shoot():
	var bullet = Bullet.instantiate()

	var dir = Vector2.RIGHT.rotated($Muzzle.global_rotation)
	# spawn bullet slightly in front of the muzzle
	bullet.global_position = $Muzzle.global_position + dir * 12
	bullet.global_rotation = $Muzzle.global_rotation

	get_tree().current_scene.add_child(bullet)

	# ignore collisions with the player
	bullet.add_collision_exception_with(self)
	
	

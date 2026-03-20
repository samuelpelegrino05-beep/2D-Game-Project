extends CharacterBody2D

@export var SPEED: float = 200.0
@export var DASH_SPEED: float = 400.0
@export var DASH_TIME: float = 0.15

@onready var animated_sprite = $AnimatedSprite2D
var last_direction := Vector2.DOWN

var dash_velocity = Vector2.ZERO
var dash_timer = 0.0
var is_moving = true

# Wand
var wand_scene = preload("res://wand.tscn")
var wand = null

func _ready():
	# Instantiate the wand and attach it to the player
	play_anim("Idle_Down")
	wand = wand_scene.instantiate()
	add_child(wand)
	wand.owner_body = self  # wand knows its owner
	wand.position = Vector2(9, 5)  # initial offset

func _physics_process(delta):
	if Input.is_action_just_pressed("Dash") and is_moving:
		start_dash()

	move_character(delta)

	# Wand rotation and fire
	if wand:
		wand.position = Vector2(9, 5)
		wand.look_at(get_global_mouse_position())
		
		if Input.is_action_just_pressed("Fire"):
			wand.shoot()

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
		last_direction = direction

	velocity = direction * SPEED

	# Dash
	if dash_timer > 0:
		velocity += dash_velocity
		dash_timer -= delta
	else:
		dash_velocity = Vector2.ZERO

	move_and_slide()
	update_animation(direction)

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
		direction = Vector2.RIGHT.rotated(rotation)

	dash_velocity = direction.normalized() * DASH_SPEED
	dash_timer = DASH_TIME

func update_animation(direction: Vector2):
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			play_anim("Walk_Side")
			animated_sprite.flip_h = direction.x < 0
		elif direction.y < 0:
			play_anim("Walk_Up")
		else:
			play_anim("Walk_Down")
	else:
		if abs(last_direction.x) > abs(last_direction.y):
			play_anim("Idle_Side")
			animated_sprite.flip_h = last_direction.x < 0
		elif last_direction.y < 0:
			play_anim("Idle_Up")
		else:
			play_anim("Idle_Down")

func play_anim(name: String):
	if animated_sprite.animation != name:
		animated_sprite.play(name)

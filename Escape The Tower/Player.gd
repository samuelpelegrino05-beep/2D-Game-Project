extends CharacterBody2D

# ===== Player stats =====
@export var SPEED: float = 200.0
@export var DASH_SPEED: float = 400.0
@export var DASH_TIME: float = 0.15

@export var max_health = 5
@export var invincible_time = 0.5

@export var wand_scene = preload("res://wand.tscn")

# ===== State variables =====
var health: int
var is_invincible = false
var is_dead = false

var last_direction := Vector2.DOWN
var dash_velocity = Vector2.ZERO
var dash_timer = 0.0
var is_moving = true

# ===== Nodes =====
@onready var animated_sprite = $PLAYER_SPRITE
var wand = null

# ===== Initialization =====
func _ready():
	get_tree().paused = false  # make sure the game is not paused at start
	health = max_health
	play_anim("Idle_Down")
	print(self.get_path())

	# Spawn wand
	wand = wand_scene.instantiate()
	add_child(wand)
	wand.owner_body = self
	wand.position = Vector2(9, 5)

# ===== Physics =====
func _physics_process(delta):
	if is_dead:
		return

	# Dash input
	if Input.is_action_just_pressed("Dash") and is_moving:
		start_dash()

	move_character(delta)

	# Wand rotation and fire
	if wand:
		wand.position = Vector2(9, 5)
		wand.look_at(get_global_mouse_position())
		
		if Input.is_action_just_pressed("Fire"):
			wand.shoot()

# ===== Movement =====
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

# ===== Animations =====
func update_animation(direction: Vector2):
	if is_dead:
		return

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

# ===== Damage & Health =====
func take_damage(amount):
	if is_invincible or is_dead:
		return

	is_invincible = true
	start_invincibility()

	SoundManager.play("hit")
	GameManager.change_health(-amount)
	GameManager.subtract_score(200)

	if GameManager.player_health <= 0:
		is_dead = true
		die()

func start_invincibility():
	if animated_sprite:
		animated_sprite.modulate = Color(1, 0.5, 0.5)  # Flash red

	await get_tree().create_timer(invincible_time).timeout
	is_invincible = false

	if animated_sprite:
		animated_sprite.modulate = Color(1, 1, 1)  # Back to normal

# ===== Death =====
func die():
	is_moving = false
	velocity = Vector2.ZERO

	SoundManager.stop_music()
	SoundManager.play("player_death")
	play_death_animation()
	await get_tree().create_timer(2.5).timeout
	get_tree().reload_current_scene()
	GameManager.score = 0
	GameManager.player_health = GameManager.max_health
	SoundManager.play_music("main_music")

func play_death_animation():
	if abs(last_direction.x) > abs(last_direction.y):
		# Side death
		animated_sprite.flip_h = last_direction.x < 0
		play_anim("Death_Side")
	elif last_direction.y < 0:
		play_anim("Death_Up")
	else:
		play_anim("Death_Down")

extends CharacterBody2D

# ===== Enemy stats =====
@export var speed: float = 50
@export var damage: int = 1
@export var stop_distance: float = 10  # how close it gets to player before stopping
@export var max_health: int = 3

# ===== State =====
var health: int
var is_dead: bool = false
var move_direction: Vector2 = Vector2.ZERO
var player: CharacterBody2D = null  # reference to player

# ===== Nodes =====
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	get_tree().paused = false  # make sure the game is not paused at start
	health = max_health
	
	# Find the player dynamically
	var players = get_tree().get_nodes_in_group("character")
	if players.size() > 0:
		player = players[0]
	else:
		push_error("No player found in 'player' group!")

func _physics_process(delta):
	if is_dead or not player:
		return

	# ===== Follow player =====
	var direction = player.global_position - global_position
	var distance = direction.length()

	if distance > stop_distance:
		move_direction = direction.normalized()
	else:
		move_direction = Vector2.ZERO

	velocity = move_direction * speed
	move_and_slide()

	# ===== Damage player on collision =====
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("character") and collider.has_method("take_damage"):
			collider.take_damage(damage)

	update_animation()

# ===== Animation handling =====
func update_animation():
	if not animated_sprite:
		return

	if velocity.length() > 0:
		if animated_sprite.animation != "Run" or not animated_sprite.is_playing():
			animated_sprite.play("Run")
		animated_sprite.flip_h = velocity.x < 0
	else:
		if animated_sprite.animation != "Idle" or not animated_sprite.is_playing():
			animated_sprite.play("Idle")
		animated_sprite.flip_h = move_direction.x < 0

# ===== Damage & Death =====
func take_damage(amount: int):
	if is_dead:
		return

	health -= amount
	if health <= 0:
		is_dead = true
		die()

func die():
	if animated_sprite:
		animated_sprite.play("Death")
	await animated_sprite.animation_finished
	queue_free()

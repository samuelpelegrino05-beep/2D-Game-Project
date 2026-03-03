extends CharacterBody2D

@export var is_moving = true
@export var in_cutscene = false
@export var SPEED : float = 200.0
@export var Bullet = preload("res://bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("Fire"):
		shoot()

	# Move with collision
	move()
	move_and_slide()
	cutscene()
	dash()

func move():
	# Get input direction and apply movement
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
#this stops the player from being able to move in certain scenarios where we went them not to be able to movee
func cutscene():  
	if in_cutscene:
		is_moving = false 
		
func dash():
	if Input.is_action_pressed("Dash") and is_moving:
		if Input.is_action_pressed("Up"):
			position.y -= 5
		if Input.is_action_pressed("Down"):
			position.y += 5
		if Input.is_action_pressed("Right"):
			position.x += 5
		if Input.is_action_pressed("Left"):
			position.x -= 5		
		print(Input.is_action_just_pressed("Dash"))
		
func shoot():
	var bullet = Bullet.instantiate()
	bullet.dir = rotation
	bullet.global_transform = $Muzzle.global_transform
	get_parent().add_child(bullet)
	
	

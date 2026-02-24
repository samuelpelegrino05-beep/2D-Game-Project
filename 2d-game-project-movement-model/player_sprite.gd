extends Sprite2D

@export var is_moving = true
@export var in_cutscene = false
@export var speed = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("Up") and is_moving: 
		position.y -= 1 + speed 
	if Input.is_action_pressed("Down") and is_moving: 
			position.y += 1 + speed 
	if Input.is_action_pressed("Right") and is_moving: 
			position.x += 1 + speed
	if Input.is_action_pressed("Left") and is_moving:
			position.x -= 1 + speed
	
	#this stops the player from being able to move in certain scenarios where we went them not to be able to move
func _cutscene():  
	if in_cutscene:
		is_moving = false 
		
func _dash():
	if Input.is_action_pressed("Dash") and Input.is_action_pressed("Up") and is_moving:
		position.y -= 5
		print(Input.is_action_just_pressed("Dash"))

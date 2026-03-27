extends PathFollow2D
@export var last_position = Vector2.ZERO
var speed = 0.001
@export var interaction = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CharacterBody2D2/ORC_WARRIOR.play("ORC_RUN")
	progress_ratio += 1 * speed
	#Flip the sprite based on movement direction
	if global_position.x < last_position.x:
		print ('moving left') 
		$CharacterBody2D2/ORC_WARRIOR.flip_h = true # Facing right
	else:
		print('moving right')
		$CharacterBody2D2/ORC_WARRIOR.flip_h = false # Facing left
	last_position = global_position

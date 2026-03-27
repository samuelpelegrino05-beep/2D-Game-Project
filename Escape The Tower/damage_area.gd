extends Area2D

@export var damage: int = 1

func _ready():
	# Make sure signals are connected (optional safety)
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("character") and body.has_method("take_damage"):
		body.take_damage(damage)

extends Area2D

func _on_body_entered(body):
	print("You Died!")
	if body.is_in_group("character") and body.has_method("take_damage"):
		body.take_damage(3)

 

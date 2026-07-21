extends CharacterBody3D

var health = 10


func take_damage(damage):
	health = max(health - damage, 0)
	
	if health <= 0:
		# tu jakaś animacja
		queue_free()

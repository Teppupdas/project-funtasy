extends CharacterBody3D

@onready var model_3d = $player


var move_vector = Vector2.ZERO
const STANDARD_SPEED = 5 #standardowa i maksymalna;    dla klawiatury


enum Actions { IDLE, DASH, QUICK_ATTACK, STRONG_ATTACK, DEATH }
var current_action: Actions = Actions.IDLE
var action_direction = Vector3.FORWARD






func _ready() -> void:
	pass



func _process(delta):
	model_3d.rotation.y = atan2(-action_direction.x, -action_direction.z)





func _physics_process(delta):
	move_vector = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	set_velocity(Vector3(move_vector.x, 0, move_vector.y) * STANDARD_SPEED)

	if move_vector != Vector2.ZERO:
		action_direction = Vector3(move_vector.x, 0, move_vector.y)






	move_and_slide() #poruszanie się to powoduje

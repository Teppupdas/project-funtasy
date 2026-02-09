extends CharacterBody3D

@onready var model_3d = $player


var move_vector = Vector3.FORWARD
const STANDARD_SPEED = 2.7 #standardowa i maksymalna;    dla klawiatury


enum Actions { IDLE, DASH, QUICK_ATTACK, STRONG_ATTACK, DEATH }
var current_action: Actions = Actions.IDLE
var action_direction = Vector3.FORWARD






func _ready() -> void:
	pass



func _process(delta):
	model_3d.rotation.y = atan2(-action_direction.x, -action_direction.z)





func _physics_process(delta):
	move_vector.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	move_vector.z = (Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	move_vector = move_vector.normalized()
	
	set_velocity(move_vector * STANDARD_SPEED)

	if move_vector != Vector3.ZERO:
		action_direction = move_vector






	move_and_slide() #poruszanie się to powoduje

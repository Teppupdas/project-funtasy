extends CharacterBody3D

@onready var model_3d = $player




var max_hp: int
var current_hp: int 






enum Actions { MOVEMENT, DASH }
var current_action: Actions = Actions.MOVEMENT
var action_direction = Vector3.FORWARD

var move_vector = Vector2.ZERO
const STANDARD_SPEED = 5

var can_dash = true
const DASH_SPEED = 24
const DASH_LENGTH = 0.17
const DASH_COOLDOWN = 0.5




func _ready() -> void:
	pass



func _process(delta):
	model_3d.rotation.y = atan2(-action_direction.x, -action_direction.z)





func _physics_process(delta):
	move_vector = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	#ustawianie prędkości
	if current_action == Actions.MOVEMENT: #jeśli movement to ustawia prędkość
		set_velocity(Vector3(move_vector.x, 0, move_vector.y) * STANDARD_SPEED)
	elif current_action != Actions.DASH: #jeśli akcja (inna niż dash) to wyłącza ruch
		set_velocity(Vector3.ZERO)
	
	#przypisywanie action_direction
	if move_vector != Vector2.ZERO and current_action == Actions.MOVEMENT:
		action_direction = Vector3(move_vector.x, 0, move_vector.y)



	#wybór akcji
	if current_action == Actions.MOVEMENT:
		
		#Dash
		if Input.is_action_just_pressed("dash") and can_dash and move_vector != Vector2.ZERO:
			current_action = Actions.DASH
			can_dash = false
			set_velocity(action_direction * DASH_SPEED)
			await get_tree().create_timer(DASH_LENGTH).timeout
			current_action = Actions.MOVEMENT
			await get_tree().create_timer(DASH_COOLDOWN).timeout
			can_dash = true




	move_and_slide() #poruszanie się to powoduje

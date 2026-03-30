
#
#
#enum Actions { MOVEMENT, DASH }
#var current_action: Actions = Actions.MOVEMENT
#var action_direction = Vector3.FORWARD
#
#var move_vector = Vector2.ZERO
#const STANDARD_SPEED = 5
#

#
#
#
#func _physics_process(delta):
	#move_vector = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	#
	##ustawianie prędkości
	#if current_action == Actions.MOVEMENT: #jeśli movement to ustawia prędkość
		#set_velocity(Vector3(move_vector.x, 0, move_vector.y) * STANDARD_SPEED)
	#elif current_action != Actions.DASH: #jeśli akcja (inna niż dash) to wyłącza ruch
		#set_velocity(Vector3.ZERO)
	#
	##przypisywanie action_direction
	#if move_vector != Vector2.ZERO and current_action == Actions.MOVEMENT:
		#action_direction = Vector3(move_vector.x, 0, move_vector.y)
#
#
#
	##wybór akcji
	#if current_action == Actions.MOVEMENT:
		#
		##Dash
		#if Input.is_action_just_pressed("dash") and can_dash and move_vector != Vector2.ZERO:
			#current_action = Actions.DASH
			#can_dash = false
			#set_velocity(action_direction * DASH_SPEED)
			#await get_tree().create_timer(DASH_LENGTH).timeout
			#current_action = Actions.MOVEMENT
			#await get_tree().create_timer(DASH_COOLDOWN).timeout
			#can_dash = true
#
#

extends CharacterBody3D


@onready var camera_pivot = $CameraPivot 
@onready var model_3d = $player

var max_hp: int = 100
var current_hp: int = 100



var move_vector = Vector3.ZERO
var move_speed = 7.0
var rotation_speed = 0.15
var braking_speed = 1.5

var jump_velocity = 7.0
var short_jump_gravity = 16
var long_jump_gravity = 10
var fall_gravity = 27






func _physics_process(delta):
	movement(delta)
	jump_and_gravity(delta)
	move_and_slide() # poruszanie sie to powoduje




func movement(delta):
	
	# pobranie input dla ruchu
	var input_vector = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	# pobranie obrotu z kamery
	var cam_basis = camera_pivot.global_transform.basis
	var forward = Vector3(cam_basis.z.x, 0, cam_basis.z.z).normalized()
	var right = Vector3(cam_basis.x.x, 0, cam_basis.x.z).normalized()
	
	# ustawienie kierunku ruchu
	move_vector = (forward * input_vector.y + right * input_vector.x).normalized()


	if move_vector != Vector3.ZERO:
		# przypisanie prędkości
		velocity.x = move_vector.x * move_speed
		velocity.z = move_vector.z * move_speed
		
		# wykonanie obrotu
		model_3d.rotation.y = lerp_angle(model_3d.rotation.y, atan2(forward.x, forward.z), rotation_speed)
	else:
		# płynne zatrzymanie
		velocity.x = move_toward(velocity.x, 0, braking_speed)
		velocity.z = move_toward(velocity.z, 0, braking_speed)

func jump_and_gravity(delta):
	
		# skok
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	
	if not is_on_floor():
		if velocity.y > 0: # wznoszenie
			if Input.is_action_pressed("jump"):
				velocity.y -= long_jump_gravity * delta
			else:
				velocity.y -= short_jump_gravity * delta
		else:
			# spadanie
			velocity.y -= fall_gravity * delta

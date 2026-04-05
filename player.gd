
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
var weak_gravity = 13.0
var strong_gravity = 27.0
var jump_cut = 2.5
var coyote_time = 0.1
var buffer_time = 0.1

var coyote_timer = coyote_time
var buffer_timer = 0
var current_gravity = weak_gravity




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

	# timer menagement
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer = max(0, coyote_timer - delta)

	buffer_timer = max(0, buffer_timer - delta)



	# inputy
	if Input.is_action_just_pressed("jump"):
		buffer_timer = buffer_time
	
	if Input.is_action_just_released("jump"):
		current_gravity = strong_gravity



	# wykonanie skoku
	if coyote_timer > 0 and buffer_timer > 0:
		coyote_timer = 0
		buffer_timer = 0
		current_gravity = weak_gravity
		velocity.y = jump_velocity



	# grawitacja
	if is_on_floor():
		if velocity.y < 0:
			velocity.y = 0
	else:
		if velocity.y < 0:
			current_gravity = strong_gravity
		
		velocity.y -= current_gravity * delta

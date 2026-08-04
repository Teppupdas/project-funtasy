
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














extends CharacterBody3D

@onready var camera = $Camera3D
@onready var damageArea = $DamageArea


var max_hp: int = 100
var current_hp: int = 100


# move
var move_direction = Vector3.ZERO
var move_speed = 7.0
var rotation_speed = 0.15
var braking_speed = 1.5

# jump
var jump_velocity = 7.0
var weak_gravity = 13.0
var strong_gravity = 27.0
var jump_cut = 2.5
var coyote_time = 0.1
var buffer_time = 0.1
# jump runtime
var coyote_timer = coyote_time
var buffer_timer = 0
var current_gravity = weak_gravity




var damage
var already_hit_enemies: Array = []  # przeciwnicy juz trafieni












# czułość myszki i pada
var mouse_sense = 0.001
var pad_sense = 2


func _unhandled_input(event):
	# obsługa myszki
	if event is InputEventMouseMotion:
		rotate_cam(-event.relative.x * mouse_sense, -event.relative.y * mouse_sense)

func _process(delta):
	# obsługa pada prawej gałki
	var joy = Input.get_vector("look_right", "look_left", "look_down", "look_up")
	rotate_cam(joy.x * pad_sense * delta, joy.y * pad_sense * delta) # delta ma być

func rotate_cam(x, y):
	rotate_y(x) #obraca graczem lewo-prawo
	camera.rotate_x(y) #obraca kamere góra-dół
	camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(70), deg_to_rad(70)) #blokuje kamery zakres góra-dół













func _physics_process(delta):
	movement(delta)
	jump_and_gravity(delta)
	move_and_slide() # poruszanie sie to powoduje
	
	attack()






func movement(delta):
	# pobranie input dla ruchu
	var move_input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	# ustawienie kierunku ruchu
	var move_direction = (transform.basis * Vector3(move_input.x, 0, move_input.y)).normalized()

	if move_direction != Vector3.ZERO:
		# przypisanie prędkości
		velocity.x = move_direction.x * move_speed
		velocity.z = move_direction.z * move_speed
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


func attack():
	if Input.is_action_just_pressed("attack1"):
		damage = 5
		damageArea.monitoring = true
		await get_tree().create_timer(0.1).timeout
		#await get_tree().create_timer(anim_player.get_animation("AtakRekaSzybki1").length).timeout
		
		damageArea.monitoring = false
		already_hit_enemies.clear()







func _on_damage_area_body_entered(body: Node3D) -> void:
	if body.has_method("apply_damage") and not body in already_hit_enemies:
		body.apply_damage(damage)  # wywołanie funkcji przyjmowania dmg u przeciwnika
		already_hit_enemies.append(body)  # zapamietywanie ze dany przeciwnik juz trafiony

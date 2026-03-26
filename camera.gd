extends Node3D

# czułość
var mouse_sense = 0.15
var pad_sense = 250

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED #blokada kursora i nie pokazuje go

func _unhandled_input(event):
	# obsługa myszki
	if event is InputEventMouseMotion:
		rotate_cam(event.relative.x * mouse_sense, event.relative.y * mouse_sense)


func _process(delta):
	# obsługa pada
	var joy = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	rotate_cam(joy.x * pad_sense * delta, joy.y * pad_sense * delta) # delta ma być

func rotate_cam(x, y):
	rotate_y(deg_to_rad(-x)) #obraca lewo-prawo
	
	rotation_degrees.x -= y #obraca góra-dół
	rotation_degrees.x = clamp(rotation_degrees.x, -50, 50) #blokuje zakres góra-dół

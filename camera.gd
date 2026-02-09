extends Camera3D

@onready var player = $"../World/player"

var speed = 3
var standard_offset = Vector3(0,7,7)
var look_offset = Vector2.ZERO

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	
	look_offset = Input.get_vector("look_left", "look_right", "look_forward", "look_back")




func _physics_process(delta: float) -> void:
	var target_position = player.global_position + standard_offset + (Vector3(look_offset.x, 0, look_offset.y) * 3)
	global_position = global_position.lerp(target_position, delta * speed)

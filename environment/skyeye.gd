extends Node3D
@onready var player = get_node("/root/Main/World/Player")

func _process(_delta):
	if player:
		look_at(player.global_position)

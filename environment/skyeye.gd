extends Node3D
@onready var player = $"../../Player"

func _process(_delta):
	if player:
		look_at(player.global_position)

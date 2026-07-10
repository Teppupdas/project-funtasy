extends Node3D


@onready var save_node = $"../../../../Save"
@onready var ui = $"../../../../CanvasLayer"
@onready var player = $"../../../Player"




func handle_interaction():
	ui.hide_interaction_prompt()
	
	#zapis
	var current_location_uid = ResourceUID.id_to_text(ResourceLoader.get_resource_uid(owner.scene_file_path))
	save_node.save_game(current_location_uid)
	
	#leczenie
	player.current_hp = player.max_hp
	ui.set_hp(player.max_hp, player.max_hp)








func _on_area_3d_body_entered(body: Node3D) -> void:
	ui.show_interaction_prompt(self, "save")


func _on_area_3d_body_exited(body: Node3D) -> void:
	ui.hide_interaction_prompt()

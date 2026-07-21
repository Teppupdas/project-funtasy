extends Node3D


@onready var save_node = $"../../../../Save"
@onready var ui = $"../../../../CanvasLayer"
@onready var player = $"../../../Player"




#Użycie pentagramu
func handle_interaction():
	ui.hide_interaction_prompt()
	
	#zapis
	var current_location_uid = ResourceUID.id_to_text(ResourceLoader.get_resource_uid(owner.scene_file_path))
	save_node.save_game(current_location_uid)
	
	
	#animacja jakas przykrywka
	#reset listy zabitych przeicwników
	clear_locations()
	save_node.load_game()
	
	
	
	##leczenie     chyba niepotrzebne jeśli jest load_game robione
	#player.current_hp = player.max_hp
	#ui.set_hp(player.max_hp, player.max_hp)
	
	





func clear_locations():
	var locations = owner.get_parent()
	for child in locations.get_children():
		locations.remove_child(child) # wymagane aby nazwy nodow sie zwalnialy
		child.queue_free()







func _on_area_3d_body_entered(body: Node3D) -> void:
	ui.show_interaction_prompt(self, "save")


func _on_area_3d_body_exited(body: Node3D) -> void:
	ui.hide_interaction_prompt()

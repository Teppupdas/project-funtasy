extends Node

# LOKACJE:
var LOCATION_REGISTRY = {
	"cimury": "uid://crdxyow0fwmtt",
	"krzyrzy": "uid://b44lh2cfb7oni"
}





func _on_player_trigger_detector_area_entered(area: Area3D) -> void:
	print("Trigger detected: ", area.name)
	
	
	# DODAWANIE LOKACJI
	if area.has_meta("add_location"):
		var locations_to_add = area.get_meta("add_location") as Dictionary
		
		for location in locations_to_add.keys():
			var spawn_offset = locations_to_add[location] as Vector3
			
			if LOCATION_REGISTRY.has(location):
				var location_uid = LOCATION_REGISTRY[location]
				
				var loaded_scene = load(location_uid) as PackedScene
				if loaded_scene:
					var new_location = loaded_scene.instantiate()
					add_child(new_location)
				
				
				
					#new_location.global_position = spawn_offset

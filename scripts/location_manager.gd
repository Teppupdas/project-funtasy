extends Node

# LOKACJE:
var LOCATION_REGISTRY = {
	#oldcity
	"oldcity": "uid://6lsv4y15v1ph",
	
	#bloki
	"podworko": "uid://g0cbjac744xs",
	
	#piwnice
	"cimury": "uid://crdxyow0fwmtt",
	"krzyrzy": "uid://b44lh2cfb7oni",
	"zakret": "uid://b8gj4744sjgrk",
	"dluga": "uid://besbvcer43yak",
	"palac": "uid://dye5fi6qua0ei"
}





func _ready() -> void:
	#połączenie z sygnałem TriggerDetector w scenie gracza
	var trigger = get_node("/root/Main/World/Player/TriggerDetector") 
	trigger.area_entered.connect(_on_player_trigger_detector_area_entered)




func _on_player_trigger_detector_area_entered(area: Area3D) -> void:
	print("Trigger detected: ", area.name)



	#USUWANIE LOKACJI
	if area.has_meta("remove_location"):
		var locations_to_remove = area.get_meta("remove_location") as Array
		
		for location in locations_to_remove:
			var location_node = get_node_or_null(location)
			
			if location_node:
				location_node.queue_free()




	# DODAWANIE LOKACJI
	if area.has_meta("add_location"):
		var locations_to_add = area.get_meta("add_location") as Dictionary
		
		for location in locations_to_add.keys():
			var spawn_offset = locations_to_add[location] as Vector3
			
			if LOCATION_REGISTRY.has(location):
				
				if get_node_or_null(location) != null:
					continue
				
				var location_uid = LOCATION_REGISTRY[location]
				
				var loaded_scene = load(location_uid) as PackedScene
				if loaded_scene:
					var new_location = loaded_scene.instantiate()
					add_child(new_location)
					
					new_location.global_position = area.get_parent().global_position + spawn_offset

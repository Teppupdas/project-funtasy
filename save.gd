extends Node


@onready var player = $"../World/Player"
@onready var ui = $"../CanvasLayer"


# KLCZUZE
var cimur









func _ready():
	randomize()
	call_deferred("load_game") #opóżnione wywołanie bo sie bugowało że było null instance







func save_game(current_location_uid):
	var data_file = ConfigFile.new()



# Lokacja i HP
	data_file.set_value("player", "current_location", current_location_uid)
	data_file.set_value("player", "max_hp", player.max_hp)


# przejścia klucze lokacje skróty
	data_file.set_value("keys", "cimur", cimur)



	data_file.save("user://save_game.txt")  # Zapis
	print("zapisano")













func load_game():
	var data_file = ConfigFile.new()
	data_file.load("user://save_game.txt")  # Odczyt



	#ustawienie HP
	player.max_hp = data_file.get_value("player", "max_hp", 100) # ustawianie maksymalnego zycia
	player.current_hp = data_file.get_value("player", "max_hp", 100) # ustawianianie obencego zycia
	ui.set_hp(player.max_hp, player.max_hp)


	#wczytanie lokacji
	var location_to_load = data_file.get_value("player", "current_location", "uid://g0cbjac744xs")
	var loaded_location = load(location_to_load).instantiate()
	$"../World/Locations".add_child(loaded_location)
	#ustawienie pozycji gracza w lokacji
	player.global_position = loaded_location.find_child("Pentagram", true, false).global_position




	# przejścia klucze lokacje skróty
	cimur = data_file.get_value("keys", "cimur", false)






	print("wczytano")

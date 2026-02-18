extends Node

@onready var player = $"../World/Player"
@onready var ui = $"../CanvasLayer"


var current_pentagram: Node3D = null # Przechowuje ostatni pentagram













func _ready():
	randomize()
	call_deferred("load_game") #opóżnione wywołanie bo sie bugowało że było null instance







func save_game():
	var data_file = ConfigFile.new()

	data_file.set_value("player", "pentagram", current_pentagram.name)
	data_file.set_value("player", "max_hp", player.max_hp)



	var error = data_file.save("user://save_game.txt")  # Zapis
	if error == OK:
		print("zapisano")
	else:
		print("zapis wypierdolony")


func load_game():
	var data_file = ConfigFile.new()
	var error = data_file.load("user://save_game.txt")  # Odczyt




	player.max_hp = data_file.get_value("player", "max_hp", 100) # ustawianie maksymalnego zycia
	player.current_hp = data_file.get_value("player", "max_hp", 100) # ustawianianie obencego zycia
	ui.set_hp(player.max_hp, player.max_hp)
	
	if data_file.get_value("player", "pentagram", ""):
		set_pentagram(get_node("../World/" + data_file.get_value("player", "pentagram", ""))) #zapalenie swieczki i jej wybor
		player.position = current_pentagram.position #pozycja gracza na pentagram




# pentagramm
func set_pentagram(pentagram: Node3D) -> void:
	player.current_hp = player.max_hp #leczenie gracza gdy pentagramuje
	ui.set_hp(player.max_hp, player.max_hp)
	
	current_pentagram = pentagram # przypisuje pentagram

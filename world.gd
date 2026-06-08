extends Node3D
#extends AnimatableBody3D


#@onready var platforma1 = $platforma1

var czas = 0.0
var dystans = 15.0
var predkosc = 0.3

func _physics_process(delta):
	czas += delta * predkosc
	# Platforma będzie płynnie krążyć góra-dół
	position.z = sin(czas) * dystans
	#platforma1.position.z = sin(czas) * dystans

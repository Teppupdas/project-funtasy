extends Node3D

@onready var save_node = get_node("/root/Main/Save")

@export var key: String



func _ready():
	open()





func open():
	if save_node.get(key) == true:
		queue_free()

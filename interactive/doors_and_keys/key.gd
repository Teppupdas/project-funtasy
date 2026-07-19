extends Node3D

@onready var save_node = $"../../../../Save"
@onready var ui = $"../../../../CanvasLayer"



@export var key: String
@export var door: Node



func _ready():
	if save_node.get(key) == true:
		queue_free()



func handle_interaction():
	ui.hide_interaction_prompt()
	
	save_node.set(key, true)
	
	door.open()
	
	queue_free()






func _on_area_3d_body_entered(body: Node3D) -> void:
	ui.show_interaction_prompt(self, "key:" + key)

func _on_area_3d_body_exited(body: Node3D) -> void:
	ui.hide_interaction_prompt()

extends Node3D


@onready var save_node = $"../../Save"
@onready var ui = $"../../CanvasLayer"




func handle_action():
	ui.hide_action_prompt()
	save_node.set_pentagram(self) #wysyla do save node ze pentagram chce zmienic
	save_node.save_game()







func _on_area_3d_body_entered(body: Node3D) -> void:
	ui.show_action_prompt(self, "save")


func _on_area_3d_body_exited(body: Node3D) -> void:
	ui.hide_action_prompt()

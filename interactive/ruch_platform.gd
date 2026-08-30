extends AnimatableBody3D

@export var start_pos := Vector3()
@export var end_pos := Vector3()

@export var time : float 

var pause = 3



func _ready() -> void:
	chujek()


func _process(delta: float) -> void:
	pass


func chujek():
	var move_tween = create_tween()
	move_tween.tween_property(self, "position", start_pos, time).set_trans(Tween.TRANS_SINE).set_delay(pause)
	move_tween.tween_property(self, "position", end_pos, time).set_trans(Tween.TRANS_SINE).set_delay(pause)
	await get_tree().create_timer(2 * (time + pause)).timeout
	chujek()

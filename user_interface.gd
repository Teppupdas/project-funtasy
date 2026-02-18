extends CanvasLayer

@onready var fps_label = $FPS_label
@onready var vram_label = $VRAM_label
@onready var gpu_label = $GPU_label
@onready var cpu_label = $CPU_label

@onready var hp_label = $HP_label


var action_prompt_active = false
var current_action_object = null
@onready var action_prompt_label = $ActionPromptLabel





func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN) #ukrycie myszki
	
	#TranslationServer.set_locale(OS.get_locale()) #auto jezyk z systemu. nie testowane.
	#TranslationServer.set_locale("pl")





func _process(delta: float) -> void:
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())
	vram_label.text = "VRAM: %d MB" % (Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / (1024**2))
	gpu_label.text = "GPU: %.2f ms" % (1000.0 / Performance.get_monitor(Performance.TIME_FPS))
	cpu_label.text = "CPU: %.2f ms" % (Performance.get_monitor(Performance.TIME_PROCESS) * 1000)

	if Input.is_action_just_pressed("pause"):
		get_tree().quit()


	if Input.is_action_just_pressed("action") and action_prompt_active:
		current_action_object.handle_action()




func set_hp(max_hp, current_hp):
	hp_label.text = "HP: " + str(current_hp) + "/" + str(max_hp)








func show_action_prompt(action_object: Node3D, action):
	action_prompt_active = true
	current_action_object = action_object
	action_prompt_label.text = action
	action_prompt_label.show()


func hide_action_prompt():
	action_prompt_active = false
	action_prompt_label.hide()

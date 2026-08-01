extends CanvasLayer

@onready var fps_label = $FPS_label
@onready var vram_label = $VRAM_label
@onready var gpu_label = $GPU_label
@onready var cpu_label = $CPU_label
@onready var triangles_label = $Triangles_label
@onready var drawcalls_label = $DrawCalls_label
@onready var nodes_label = $Nodes_label

@onready var locations_container = $LoadedLocations
@onready var world_locations = $"../World/Locations"





@onready var hp_label = $HP_label


var interaction_prompt_active = false
var current_interaction_object = null
@onready var interaction_prompt_label = $InteractionPromptLabel





func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN) #ukrycie myszki
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED #blokada kursora i nie pokazuje go
	
	#TranslationServer.set_locale(OS.get_locale()) #auto jezyk z systemu. nie testowane.
	#TranslationServer.set_locale("pl")





func _process(delta: float) -> void:
	refresh_locations_display(world_locations)
	
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())
	vram_label.text = "VRAM: %d MB" % (Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / (1024**2))
	gpu_label.text = "GPU: %.2f ms" % (1000.0 / Performance.get_monitor(Performance.TIME_FPS))
	cpu_label.text = "CPU: %.2f ms" % (Performance.get_monitor(Performance.TIME_PROCESS) * 1000)
	triangles_label.text = "Triangles: " + str(int(Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)))
	drawcalls_label.text = "Draw Calls: " + str(int(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)))
	nodes_label.text = "Nodes: " +str(int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT)))




	if Input.is_action_just_pressed("pause"):
		get_tree().quit()


	if Input.is_action_just_pressed("action") and interaction_prompt_active:
		current_interaction_object.handle_interaction()




func set_hp(max_hp, current_hp):
	hp_label.text = "HP: " + str(current_hp) + "/" + str(max_hp)








func show_interaction_prompt(interaction_object: Node3D, interaction):
	interaction_prompt_active = true
	current_interaction_object = interaction_object
	interaction_prompt_label.text = interaction
	interaction_prompt_label.show()


func hide_interaction_prompt():
	interaction_prompt_active = false
	interaction_prompt_label.hide()










func refresh_locations_display(world_locations):
	
	for child in locations_container.get_children():
		child.queue_free()
	
	for child in world_locations.get_children():
		
		var new_label = Label.new()
		new_label.text = child.name
		new_label.add_theme_font_size_override("font_size", 24)
		
		locations_container.add_child(new_label)

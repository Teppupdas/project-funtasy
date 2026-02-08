extends CanvasLayer

@onready var fps_label = $FPS_label
@onready var vram_label = $VRAM_label
@onready var gpu_label = $GPU_label
@onready var cpu_label = $CPU_label




func _process(delta: float) -> void:
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())
	vram_label.text = "VRAM: %d MB" % (Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / (1024**2))
	gpu_label.text = "GPU: %.2f ms" % (1000.0 / Performance.get_monitor(Performance.TIME_FPS))
	cpu_label.text = "CPU: %.2f ms" % (Performance.get_monitor(Performance.TIME_PROCESS) * 1000)

class_name BaseEnemy
extends CharacterBody3D

@onready var save_node = get_node("/root/Main/Save")


@onready var enemy_id = str(get_path()) #sciezka jako ID
@onready var current_hp = get("health") # pobranie hp z skryptu konkretnego przeciwnika
@onready var healthbar = $EnemyHealthBar/healthbar







func _ready():
	if save_node.world_state.has(enemy_id): # jesli jest wpis to ustawienie hp, jesli 0 to usuniecie
		current_hp = save_node.world_state[enemy_id]["hp"]
		if current_hp <= 0:
			queue_free()
		update_healthbar()







func apply_damage(dmg: int): #aplikacja dmg
	current_hp -= dmg
	if current_hp < 0:
		current_hp = 0
	update_healthbar()
	save_node.world_state[enemy_id] = { "hp": current_hp } # zapisanie obecnego hp do slownika

	if current_hp <= 0:
		queue_free()




func update_healthbar():
	healthbar.scale.x = float(current_hp) / float(get("health"))

class_name BaseEnemy
extends CharacterBody3D


@onready var enemy_id = str(get_path()) #sciezka jako ID
@onready var current_hp = get("full_hp") # pobranie hp z skryptu konkretnego przeciwnika
@onready var healthbar = $EnemyHealthBar/healthbar


func _ready():
	if GameState.world_state.has(enemy_id): # jesli jest wpis to ustawienie hp, jesli 0 to usuniecie
		current_hp = GameState.world_state[enemy_id]["hp"]
		if current_hp <= 0:
			queue_free()
		update_healthbar()







func apply_damage(dmg: int): #aplikacja dmg
	current_hp -= dmg
	if current_hp < 0:
		current_hp = 0
	update_healthbar()
	GameState.world_state[enemy_id] = { "hp": current_hp } # zapisanie obecnego hp do slownika

	if current_hp <= 0:
		queue_free()




func update_healthbar():
	healthbar.scale.x = float(current_hp) / float(get("full_hp"))

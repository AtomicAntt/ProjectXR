class_name CombatLevel
extends Node3D

enum GameStates {
	PLAYER,
	ENEMY
}

@export var game_state: GameStates = GameStates.PLAYER

@onready var enemy_spawn_points: Node = $EnemySpawnPoints

func _ready() -> void:
	Global.enemy_recovered.connect(on_enemy_recovered)
	Global.enemy_waiting.connect(check_waiting)
	
	match game_state:
		GameStates.PLAYER:
			$TurnLabel.text = "PLAYER TURN"
			set_player_turn()
		GameStates.ENEMY:
			$TurnLabel.text = "ENEMY TURN"
			set_enemy_turn()

# After an enemy gets hurt and thats recovering, once their recovery timer ends, this gets called.
func on_enemy_recovered(enemy_node: Enemy) -> void:
	if game_state == GameStates.PLAYER:
		set_enemy_turn()
	elif game_state == GameStates.ENEMY:
		enemy_node.set_waiting()

# Should be called whenever an enemy recovers after being attacked. Only call this during a player's turn.
func set_enemy_turn() -> void:
	game_state = GameStates.ENEMY
	$TurnLabel.text = "ENEMY TURN"
	$EnemyChargeTimer.start() # After this end, it should pick a random enemy that's idle to start charging.
	set_enemy_positions()

# If all enemies are waiting during an enemy turn, this function should get called by check_waiting() whenever an enemy gets set to waiting.
func set_player_turn() -> void:
	game_state = GameStates.PLAYER
	$TurnLabel.text = "PLAYER TURN"
	$EnemyChargeTimer.stop() # Stopping this so that enemies are no longer picked to start charging.
	set_enemy_positions()

# This function will check if all enemies are waiting during an enemy turn. If they are, then it will finally be the player's turn.
func check_waiting() -> void:
	var all_waiting: bool = true
	for enemy: Enemy in get_tree().get_nodes_in_group("Enemy"):
		if not enemy.is_waiting():
			all_waiting = false
	if all_waiting:
		set_player_turn()

## This function will set enemies to their spawn points. It should be called at the start of an enemy's turn so they can be ready to attack.
## It should also be called if there are more than one enemy during a player's turn so that one may be selected.
func set_enemy_positions() -> void:
	await get_tree().create_timer(0.1).timeout
	var enemies: Array[Enemy]
	for enemy: Enemy in get_tree().get_nodes_in_group("Enemy"):
		if is_instance_valid(enemy):
			enemies.append(enemy)
	
	# Ensure that there are not more enemies than enemy spawn points or this code breaks.
	for i in range(enemies.size()):
		var enemy: Enemy = enemies[i]
		var enemy_spawn: Marker3D = enemy_spawn_points.get_children()[i]
		enemy.global_transform = enemy_spawn.global_transform
		enemy.velocity = Vector3.ZERO
		enemy.set_idle()
		
		# Do later: Change this into a function they have as set_visible() in case they are tweening a shader or else this could cause unknown issues
		#enemy.visible = true
		
		enemy.reappear()
		
		print("enemy now visible after setting position")


func _on_enemy_charge_timer_timeout() -> void:
	if game_state == GameStates.ENEMY:
		var enemies_idle: Array[Enemy] = []
		for enemy: Enemy in get_tree().get_nodes_in_group("Enemy"):
			if enemy.is_idle():
				enemies_idle.append(enemy)
		if enemies_idle.size() > 0:
			var random_enemy: Enemy = enemies_idle.pick_random()
			if is_instance_valid(random_enemy):
				random_enemy.set_charging()

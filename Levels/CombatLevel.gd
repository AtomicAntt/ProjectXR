class_name CombatLevel
extends Node3D

enum GameStates {
	PLAYER,
	ENEMY
}

@export var game_state: GameStates = GameStates.PLAYER

@onready var enemy_spawn_points: Node = $EnemySpawnPoints

## Current enemy that is selected.
var enemy_selected: Enemy = null

## EnemySelection of the enemy selected, which has access to their spawn point.
var selected_enemy_selection: EnemySelection = null

## The speed of enemies when they are selected and tweened to positions.
var select_speed: float = 0.5

func _ready() -> void:
	Global.enemy_recovered.connect(on_enemy_recovered)
	Global.enemy_waiting.connect(check_waiting)
	Global.enemy_selected.connect(select_enemy)
	
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
		if enemies_survived():
			set_enemy_turn()
		else:
			print("Looks like you won this fight!")
	elif game_state == GameStates.ENEMY:
		if not enemy_node.is_dead():
			enemy_node.set_waiting()
		elif not enemies_survived():
			print("Looks like you won this fight! You defeated them all in the countering stage.")

func enemies_survived() -> bool:
	var all_alive: bool = false
	for enemy: Enemy in get_tree().get_nodes_in_group("Enemy"):
		if not enemy.is_dead():
			all_alive = true
	return all_alive

# Should be called whenever an enemy recovers after being attacked. Only call this during a player's turn.
func set_enemy_turn() -> void:
	game_state = GameStates.ENEMY
	$TurnLabel.text = "ENEMY TURN"
	$EnemyChargeTimer.start() # After this end, it should pick a random enemy that's idle to start charging.
	set_enemy_positions()
	disable_item_slots()
	
	for enemy_selection: EnemySelection in get_tree().get_nodes_in_group("EnemySelection"):
		enemy_selection.disable()

# If all enemies are waiting during an enemy turn, this function should get called by check_waiting() whenever an enemy gets set to waiting.
func set_player_turn() -> void:
	game_state = GameStates.PLAYER
	$TurnLabel.text = "PLAYER TURN"
	$EnemyChargeTimer.stop() # Stopping this so that enemies are no longer picked to start charging.
	set_enemy_positions()
	enable_item_slots()


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
		
		if game_state == GameStates.PLAYER:
			var enemy_selection: EnemySelection = enemy_spawn.get_node("EnemySelection")
			enemy_selection.enable()
		# Do later: Change this into a function they have as set_visible() in case they are tweening a shader or else this could cause unknown issues
		#enemy.visible = true
		
		enemy.reappear()

func is_all_idle() -> bool:
	var all_idle: bool = true
	for enemy: Enemy in get_tree().get_nodes_in_group("Enemy"):
		if not enemy.is_idle():
			all_idle = false
	
	return all_idle

## Whenever an EnemySelection is pressed, it emits a signal from Global which this class listens to.
## If all enemies are idle (and thus, not in the process of getting hurt -> enemy turn), they may be tweenened.
## If there exists an enemy selected already, the enemies will swap.
func select_enemy(new_enemy_selection: EnemySelection, new_enemy_selected: Enemy) -> void:
	if is_all_idle():
		var tween = create_tween()
		
		# If there is already an enemy selected, send them back to their spawn point's position.
		if is_instance_valid(enemy_selected):
			var swap_tween = create_tween()
			selected_enemy_selection.enable() # Make it so you can once again select the enemy.
			swap_tween.tween_property(enemy_selected, "global_position", selected_enemy_selection.get_spawn_point().global_position, select_speed)
			enemy_selected = null
			selected_enemy_selection = null
		
		# Send the selected enemy to the selected enemy marker position.
		enemy_selected = new_enemy_selected
		selected_enemy_selection = new_enemy_selection
		selected_enemy_selection.disable() # Make it so you can not select the EnemySelection that is already selected.
		tween.tween_property(new_enemy_selected, "global_position", $SelectedEnemyMarker.global_position, select_speed)

func disable_item_slots() -> void:
	for item_slot: ItemSlot in get_tree().get_nodes_in_group("ItemSlot"):
		if not item_slot.is_in_group("WeaponItemSlot"):
			item_slot.instant_grab()
			item_slot.enabled = false
			item_slot.visible = false # Item slot picked up items will share visibility, no worries

func enable_item_slots() -> void:
	for item_slot: ItemSlot in get_tree().get_nodes_in_group("ItemSlot"):
		if not item_slot.is_in_group("WeaponItemSlot"):
			item_slot.enabled = true
			item_slot.visible = true # Item slot picked up items will share visibility, no worries

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

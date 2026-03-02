class_name CombatLevel
extends Node3D

enum GameStates {
	PLAYER,
	ENEMY
}

var game_state: GameStates = GameStates.PLAYER

@onready var enemy_spawn_points: Node = $EnemySpawnPoints

func _ready() -> void:
	# Yes, it will set the game state to enemy turn regardless of if it is already, but it will probably not matter.
	Global.enemy_recovered.connect(set_enemy_turn)
	Global.enemy_waiting.connect(check_waiting)
	
	match game_state:
		GameStates.PLAYER:
			$TurnLabel.text = "PLAYER TURN"
		GameStates.ENEMY:
			$TurnLabel.text = "ENEMY TURN"

# Should be called whenever an enemy recovers after being attacked. If they get attacked/countered during an enemy turn, it won't matter hopefully.
func set_enemy_turn() -> void:
	if game_state != GameStates.ENEMY:
		game_state = GameStates.ENEMY
		$TurnLabel.text = "ENEMY TURN"
		set_enemy_positions()

# If all enemies are waiting during an enemy turn, this function should get called.
func set_player_turn() -> void:
	game_state = GameStates.PLAYER
	$TurnLabel.text = "PLAYER TURN"
	

## This function will check if all enemies are waiting during an enemy turn. If they are, then it will finally be the player's turn.
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
	# Ensure that there are not more enemies than enemy spawn points or this code breaks.
	for i in range(get_tree().get_node_count_in_group("Enemy")):
		var enemy: Enemy = get_tree().get_nodes_in_group("Enemy")[i]
		var enemy_spawn: Marker3D = enemy_spawn_points.get_children()[i]
		enemy.global_transform = enemy_spawn.global_transform
		enemy.velocity = Vector3.ZERO
		enemy.set_idle()
		
		# Do later: Change this into a function they have as set_visible() in case they are tweening a shader or else this could cause unknown issues
		#enemy.visible = true
		
		enemy.reappear()
		
		print("enemy now visible after setting position")

extends Node

# SceneLoader will connect to this signal, once it's emitted, it will do the deed
signal transition_scene(scene_name: String)
signal goto_action(index: int)
signal confirm_dialogue

signal enemy_waiting
signal enemy_recovered(enemy_node: Enemy)

signal enemy_selected(enemy_selection: EnemySelection, enemy_node: Enemy)

## Emits a signal which the SceneLoader may listen to
func switch_scene(scene_name: String) -> void:
	emit_signal("transition_scene", scene_name)

## Tells a DialogueContainer to go to a certain index/id of the text after a choice is selected
func goto(index: int) -> void:
	emit_signal("goto_action", index)

func emit_confirm_dialogue() -> void:
	emit_signal("confirm_dialogue")

## Signal is emitted by an enemy during an enemy's turn if they are set to waiting after being countered or otherwise stopped attacking.
func emit_enemy_waiting() -> void:
	emit_signal("enemy_waiting")

## Signal is emitted whenever they are hit. This can be either when the player hits them on the player turn or when an enemy gets countered.
func emit_enemy_recovered(enemy_node: Enemy) -> void:
	emit_signal("enemy_recovered", enemy_node)

## Signal emitted whenever an EnemySelection is selected during the player's turn. CombatLevel must listen in and take care of things.
func emit_enemy_selected(enemy_selection: EnemySelection, enemy_node: Enemy) -> void:
	emit_signal("enemy_selected", enemy_selection, enemy_node)

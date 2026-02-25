extends Node

# SceneLoader will connect to this signal, once it's emitted, it will do the deed
signal transition_scene(scene_name: String)
signal goto_action(index: int)
signal confirm_dialogue

## Emits a signal which the SceneLoader may listen to
func switch_scene(scene_name: String) -> void:
	emit_signal("transition_scene", scene_name)

## Tells a DialogueContainer to go to a certain index/id of the text after a choice is selected
func goto(index: int) -> void:
	emit_signal("goto_action", index)

func emit_confirm_dialogue() -> void:
	emit_signal("confirm_dialogue")

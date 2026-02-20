extends Node

# SceneLoader will connect to this signal, once it's emitted, it will do the deed
signal transition_scene(scene_name: String)

## Emits a signal which the SceneLoader may listen to
func switch_scene(scene_name: String) -> void:
	emit_signal("transition_scene", scene_name)

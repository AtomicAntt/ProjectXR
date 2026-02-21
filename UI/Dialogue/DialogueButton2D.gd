class_name DialogueButton2D
extends Node2D

## If a scene_name is given, then pressing this dialogue button will switch scenes to the given name.
var scene_name: String = "GrassLevel"

func _on_button_pressed() -> void:
	Global.switch_scene(scene_name)

class_name DialogueButton2D
extends Node2D

@onready var text_label: Button = $Button
var function_called: String
var arguments_given: Array[String]

func _on_button_pressed() -> void:
	#Global.switch_scene(scene_name)
	print("button pressed")

func set_text(new_text: String) -> void:
	text_label.text = new_text

func set_function(new_function: String) -> void:
	function_called = new_function

func set_arguments(new_arguments: Array[String]) -> void:
	for i in range(new_arguments.size()):
		arguments_given[i] = new_arguments[i]

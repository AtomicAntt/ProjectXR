class_name DialogueButton2D
extends Node2D

@onready var text_label: Button = $Button

## This will be a dictionary where the key is the function name and the value will be an array of arguments.
var functions_called: Dictionary

func _on_button_pressed() -> void:
	call_functions()
	Global.emit_confirm_dialogue()

func set_text(new_text: String) -> void:
	text_label.text = new_text

func set_functions(functions: Dictionary) -> void:
	for function_given in functions:
		functions_called[function_given] = functions[function_given]

func call_functions() -> void:
	for function_given: String in functions_called:
		call(function_given, functions_called[function_given])

func teleport(scene_name: String) -> void:
	Global.switch_scene(scene_name)

func goto(index: int) -> void:
	Global.goto(index)

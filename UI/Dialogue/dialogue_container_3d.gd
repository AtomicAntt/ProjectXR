class_name DialogueContainer
extends Node3D

var dialogue_choice3D: PackedScene = preload("res://UI/Dialogue/DialogueChoice3D.tscn")

@onready var dialogue_text: Dialogue3D = $DialogueText
@onready var dialogue_text_2d: DialogueText2D = dialogue_text.get_scene_instance()
@export var text_offset: float = 0.4 # offset between the text and the first option
@export var choice_offset: float = 0.25


func _ready() -> void:
	add_option("Yo, teleport me", "", [])
	add_option("JK", "", [])

func set_text(new_text: String) -> void:
	dialogue_text_2d.set_text(new_text)

func get_text() -> String:
	return dialogue_text_2d.get_text()

func add_option(text: String, function_name: String, arguments_passed: Array[String]) -> void:
	var dialogue_choice3D_instance: Dialogue3D = dialogue_choice3D.instantiate()
	add_child(dialogue_choice3D_instance)
	dialogue_choice3D_instance.global_position = dialogue_text.global_position - Vector3(0, ((get_child_count()-2)*choice_offset) + text_offset, 0)
	
	var dialogue_choice2D: DialogueButton2D = dialogue_choice3D_instance.get_scene_instance()
	dialogue_choice2D.set_text(text)
	dialogue_choice2D.set_function(function_name)
	dialogue_choice2D.set_arguments(arguments_passed)

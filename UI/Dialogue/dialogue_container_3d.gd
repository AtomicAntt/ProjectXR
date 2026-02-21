class_name DialogueContainer
extends Node3D

var dialogue_text3D: PackedScene = preload("res://UI/Dialogue/DialogueText3D.tscn")
var dialogue_text2D: PackedScene = preload("res://UI/Dialogue/DialogueText2D.tscn")
var dialogue_choice3D: PackedScene = preload("res://UI/Dialogue/DialogueChoice3D.tscn")
var dialogue_choice2D: PackedScene = preload("res://UI/Dialogue/DialogueChoice2D.tscn")

@onready var dialogue_text: Dialogue3D = $DialogueText
@onready var dialogue_text_2d: DialogueText2D = dialogue_text.get_scene_instance()

func set_text(new_text: String) -> void:
	dialogue_text_2d.set_text(new_text)

func get_text() -> String:
	return dialogue_text_2d.get_text()

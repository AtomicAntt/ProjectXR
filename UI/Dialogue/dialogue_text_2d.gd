class_name DialogueText2D
extends Node2D

@onready var text_label: RichTextLabel = $VBoxContainer/DialoguePanel/MarginContainer/RichTextLabel

func get_text() -> String:
	return text_label.text

func set_text(new_text: String) -> void:
	text_label.text = new_text

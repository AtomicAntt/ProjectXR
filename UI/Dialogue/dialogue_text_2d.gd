class_name DialogueText2D
extends Node2D

@onready var text_label: RichTextLabel = $VBoxContainer/DialoguePanel/MarginContainer/RichTextLabel

@export var characters_per_second: float = 35
var tween: Tween

## Answers the dialogue awaiting a trigger response to move on to the next dialogue text. Likely awaiting at a DialogueContainer.
signal confirm_dialogue

## This should emit when the text is fully visible. Purpose: elements like dialogue options/choices should become visible after all text can be read.
signal text_completed

func get_text() -> String:
	return text_label.text

func set_text(new_text: String) -> void:
	text_label.text = new_text

func write_text() -> void:
	tween = get_tree().create_tween()
	tween.tween_property(text_label, "visible_ratio", 1, get_text().length()/characters_per_second)
	tween.finished.connect(emit_text_completed)

## Call this function to skip dialogue to completion that is currently writing or move on to the next dialogue text if any exists. 
## Probably called when the user hits the trigger button on any of their controllers. Preferably, it would be the one not holding an item that can do an action.
func proceed_dialogue() -> void:
	if text_label.visible_ratio < 1:
		tween.stop()
		text_label.visible_ratio = 1
		emit_text_completed()
	else:
		emit_signal("confirm_dialogue")


func emit_text_completed() -> void:
	emit_signal("text_completed")

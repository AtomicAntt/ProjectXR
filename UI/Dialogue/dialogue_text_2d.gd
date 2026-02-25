class_name DialogueText2D
extends Node2D

@onready var text_label: RichTextLabel = $VBoxContainer/DialoguePanel/MarginContainer/RichTextLabel

var characters_per_second: float = 35
var tween: Tween

## This should emit when the text is fully visible. Purpose: elements like dialogue options/choices should become visible after all text can be read.
signal text_completed

func get_text() -> String:
	return text_label.text

func set_text(new_text: String) -> void:
	text_label.text = new_text

func write_text() -> void:
	text_label.visible_ratio = 0
	tween = get_tree().create_tween()
	tween.tween_property(text_label, "visible_ratio", 1, (get_text().length())/characters_per_second)
	tween.finished.connect(emit_text_completed)

## Call this function to skip dialogue to completion that is currently writing or move on to the next dialogue text if any exists. 
## Probably called when the user hits the trigger button on any of their controllers. Preferably, it would be the one not holding an item that can do an action.
func proceed_dialogue() -> void:
	if text_label.visible_ratio < 1:
		tween.stop()
		text_label.visible_ratio = 1
		emit_text_completed()
	else:
		if get_tree().get_node_count_in_group("DialogueChoice") == 0:
			Global.emit_confirm_dialogue()


func emit_text_completed() -> void:
	emit_signal("text_completed")

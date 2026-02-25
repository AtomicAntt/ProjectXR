extends XROrigin3D

func _on_trigger_button_pressed(name: String) -> void:
	if name == "trigger_click":
		get_tree().call_group("DialogueText2D", "proceed_dialogue")

extends XROrigin3D

@warning_ignore("shadowed_variable_base_class")
func _on_trigger_button_pressed(name: String) -> void:
	if name == "trigger_click":
		get_tree().call_group("DialogueText2D", "proceed_dialogue")
	
func _process(_delta: float) -> void:
	$LeftHand/FPSLabel.text = str(Engine.get_frames_per_second())

func _on_left_function_pickup_has_hover_entered_ranged(what: Variant) -> void:
	$LeftHand/PickupIndicator.visible = true
	$LeftHand/PickupIndicator.start(what)

func _on_right_function_pickup_has_hover_entered_ranged(what: Variant) -> void:
	$RightHand/PickupIndicator.visible = true
	$RightHand/PickupIndicator.start(what)

func _on_left_function_pickup_has_hover_exited() -> void:
	$LeftHand/PickupIndicator.visible = false
	$LeftHand/PickupIndicator.stop()

func _on_right_function_pickup_has_hover_exited() -> void:
	$RightHand/PickupIndicator.visible = false
	$RightHand/PickupIndicator.stop()

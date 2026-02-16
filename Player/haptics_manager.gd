extends Node

@onready var pickup_rumbler: XRToolsRumbler = $PickUpRumbler
@onready var hover_rumbler: XRToolsRumbler = $HoverItemRumbler
@onready var pointer_hover_rumbler: XRToolsRumbler = $PointerHoverRumbler

func _on_left_hand_picked_up(_what: Variant) -> void:
	pickup_rumbler.rumble_hand($"../LeftHand")

func _on_right_hand_picked_up(_what: Variant) -> void:
	pickup_rumbler.rumble_hand($"../RightHand")

func _on_left_hand_hover_entered() -> void:
	print("left hover")
	hover_rumbler.rumble_hand($"../LeftHand")

func _on_right_hand_hover_entered() -> void:
	hover_rumbler.rumble_hand($"../RightHand")
	
func _on_left_function_pointer_pointing_event(event: XRToolsPointerEvent) -> void:
	if event.event_type == XRToolsPointerEvent.Type.ENTERED:
		if event.target.is_in_group("DialogueChoice"):
			pointer_hover_rumbler.rumble_hand($"../LeftHand")

func _on_right_function_pointer_pointing_event(event: XRToolsPointerEvent) -> void:
	if event.event_type == XRToolsPointerEvent.Type.ENTERED:
		if event.target.is_in_group("DialogueChoice"):
			pointer_hover_rumbler.rumble_hand($"../RightHand")

extends Node

@onready var pickup_rumbler: XRToolsRumbler = $PickUpRumbler
@onready var hover_rumbler: XRToolsRumbler = $HoverItemRumbler

func _on_left_hand_picked_up(_what: Variant) -> void:
	pickup_rumbler.rumble_hand($"../LeftHand/LeftHand")

func _on_right_hand_picked_up(_what: Variant) -> void:
	pickup_rumbler.rumble_hand($"../RightHand/RightHand")

func _on_left_hand_hover_entered() -> void:
	hover_rumbler.rumble_hand($"../LeftHand/LeftHand")

func _on_right_hand_hover_entered() -> void:
	hover_rumbler.rumble_hand($"../RightHand/RightHand")

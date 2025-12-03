extends Node

@onready var rumbler := $XRToolsRumbler

func _on_left_hand_picked_up(_what: Variant) -> void:
	rumbler.rumble_hand($"../LeftHand/LeftHand")

func _on_right_hand_picked_up(_what: Variant) -> void:
	rumbler.rumble_hand($"../RightHand/RightHand")

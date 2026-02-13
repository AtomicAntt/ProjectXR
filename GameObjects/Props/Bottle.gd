extends Node3D

#@export var fill_amount: float = 0.5
#
#func _ready() -> void:
	#set_fill(fill_amount)

func set_fill(amount: float) -> void:
	$Liquid.set_fill(amount)

func set_liquid_visible(set_visible: bool) -> void:
	$Liquid.visible = set_visible

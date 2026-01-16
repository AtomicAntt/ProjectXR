extends Node3D

@export var fill_amount: float = 0.5

func _ready() -> void:
	set_fill(fill_amount)

func set_fill(amount: float) -> void:
	$liquid.set_fill(amount)

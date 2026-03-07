class_name HealthBar2D
extends Node2D

func set_value(health: float) -> void:
	$ProgressBar.value = health

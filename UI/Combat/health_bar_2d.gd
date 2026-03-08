class_name HealthBar2D
extends Node2D

var tween: Tween

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var damage_indicator: ProgressBar = $ProgressBar/DamageIndicator

func set_value(health: float) -> void:
	progress_bar.value = health
	set_damage_indicator(health)
	
func set_damage_indicator(health: float) -> void:
	tween = create_tween()
	tween.tween_property(damage_indicator, "value", health, 0.5)

class_name Fade
extends MeshInstance3D

## Signal called when fade in completes
signal fade_in_complete

## Signal called when fade out completes
signal fade_out_complete

@export var fade_material: ShaderMaterial
var tween: Tween

func fade_in() -> void:
	visible = true
	tween = create_tween()
	tween.tween_method(set_fade, 0.0, 1.0, 1.0)
	await tween.finished
	emit_signal("fade_in_complete")
	

func fade_out() -> void:
	tween = create_tween()
	tween.tween_method(set_fade, 1.0, 0.0, 1.0)
	await tween.finished
	visible = false
	emit_signal("fade_out_complete")

func set_fade(alpha_value: float) -> void:
	fade_material.set_shader_parameter("albedo", Color(0, 0, 0, alpha_value))

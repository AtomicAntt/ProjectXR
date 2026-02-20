class_name Fade
extends MeshInstance3D

## Use this to create XR full screen effects

@export var fade_material: ShaderMaterial
var tween: Tween

func fade_in() -> void:
	visible = true
	tween = create_tween()
	tween.tween_method(set_fade, 0.0, 1.0, 1.0)
	await tween.finished

func fade_out() -> void:
	tween = create_tween()
	tween.tween_method(set_fade, 1.0, 0.0, 1.0)
	await tween.finished
	visible = false

func set_fade(alpha_value: float) -> void:
	fade_material.set_shader_parameter("albedo", Color(1, 1, 1, alpha_value))

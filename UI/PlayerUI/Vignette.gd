class_name Vignette
extends MeshInstance3D

@export var vignette_shader: ShaderMaterial
@export var initial_radius: float = 0.3
@export var final_radius: float = 1.0

func play_effect() -> void:
	visible = true
	var tween = create_tween()
	tween.tween_method(set_radius, initial_radius, final_radius, 0.5)
	await tween.finished
	visible = false

func set_radius(new_radius: float) -> void:
	vignette_shader.set_shader_parameter("radius", new_radius)

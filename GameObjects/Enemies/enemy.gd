class_name Enemy
extends CharacterBody3D

enum States {IDLE, CHARGING, ATTACKING, DEAD}
var state: States = States.IDLE

@onready var mesh_material: ShaderMaterial = $Slime/Sphere.material_overlay

@export var health: float = 100

func set_hit_flash(value: float) -> void:
		mesh_material.set_shader_parameter("flash", value)

func hurt(damage_taken: float) -> void:
	if state != States.DEAD:
		health -= damage_taken
		mesh_material.set_shader_parameter("flash", 1.0)
		var tween: Tween = create_tween()
		tween.tween_method(set_hit_flash, 1.0, 0.0, 0.5)
		
		if health <= 0:
			death()

func death() -> void:
	state = States.DEAD

class_name EnemySelection
extends StaticBody3D

var enabled: bool = false

## Distance the enemy has to be to this EnemySelection to be considered the selected enemy.
@export var distance_threhsold: float = 0.3
var tween: Tween

@onready var shader_material: ShaderMaterial = $SelectionCircle.material_override
@onready var standard_material: StandardMaterial3D = $SelectionCylinder.material_override

@onready var initial_alpha: float = standard_material.albedo_color.a
@onready var initial_border_width: float = 0.02

func _ready() -> void:
	# This is so that it starts out invisible
	set_cylinder_alpha(0)

func pointer_event(event: XRToolsPointerEvent) -> void:
	if enabled and event.event_type == event.Type.ENTERED:
		hover()
	elif event.event_type == event.Type.EXITED:
		exit_hover()
	
	if enabled and event.event_type == event.Type.PRESSED:
		if has_valid_enemy():
			Global.emit_enemy_selected(self, return_valid_enemy())

func enable() -> void:
	enabled = true
	add_to_group("PointerInteractable") # Enables haptic feedback.
	
	# Allows pointers to collide with this
	set_collision_layer_value(21, true)
	set_collision_layer_value(23, true)

func disable() -> void:
	enabled = false
	remove_from_group("PointerInteractable") # Disables haptic feedback.
	
	# Disallows pointers to collide with this
	set_collision_layer_value(21, false)
	set_collision_layer_value(23, false)

func hover() -> void:
	tween = create_tween()
	tween.tween_method(set_border_width, get_border_width(), initial_border_width, 0.2)
	tween.tween_method(set_cylinder_alpha, get_cylinder_alpha(), initial_alpha, 0.05)

func exit_hover() -> void:
	tween = create_tween()
	tween.tween_method(set_border_width, get_border_width(), 0, 0.2)
	tween.tween_method(set_cylinder_alpha, get_cylinder_alpha(), 0.0, 0.05)

func set_border_width(width_value: float) -> void:
	shader_material.set_shader_parameter("border_width", width_value)

func get_border_width() -> float:
	return shader_material.get_shader_parameter("border_width")

func get_cylinder_alpha() -> float:
	return standard_material.albedo_color.a

func set_cylinder_alpha(alpha_value: float) -> void:
	standard_material.albedo_color.a = alpha_value

func find_closest_enemy() -> Enemy:
	var closest_distance: float = INF
	var closest_enemy: Enemy = null
	for enemy: Enemy in get_tree().get_nodes_in_group("Enemy"):
		if global_position.distance_squared_to(enemy.global_position) < closest_distance:
			closest_distance = global_position.distance_squared_to(enemy.global_position)
			closest_enemy = enemy
	
	return closest_enemy

func return_valid_enemy() -> Enemy:
	var closest_enemy: Enemy = find_closest_enemy()
	if closest_enemy.global_position.distance_to(global_position) <= distance_threhsold:
		return closest_enemy
	else:
		return null

## Called by CombatLevel so that they can figure out which EnemySpawn Marker3D to put the enemy back at when another is selected and needs to swap.
func get_spawn_point() -> Marker3D:
	return get_parent()

func has_valid_enemy() -> bool:
	return is_instance_valid(return_valid_enemy())
	

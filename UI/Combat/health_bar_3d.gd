@tool
class_name HealthBar3D
extends XRToolsViewport2DIn3D

@onready var xr_camera: XRCamera3D = get_tree().get_nodes_in_group("XRCamera3D")[0]

func _physics_process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		look_at(xr_camera.global_position, Vector3.UP, true)

func set_value(health: float) -> void:
	var health_bar_2d: HealthBar2D = get_scene_instance()
	health_bar_2d.set_value(health)

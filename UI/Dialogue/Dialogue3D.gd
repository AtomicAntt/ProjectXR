@tool
class_name Dialogue3D
extends XRToolsViewport2DIn3D

## Generic node for dialogue UI elements like the text and buttons

@onready var xr_camera: XRCamera3D = get_tree().get_nodes_in_group("XRCamera3D")[0]

func _physics_process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		look_at(xr_camera.global_position, Vector3.UP, true)

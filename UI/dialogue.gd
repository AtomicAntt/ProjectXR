extends Node

var xr_camera: XRCamera3D
var dialogue_node: Node3D

func _ready() -> void:
	xr_camera = get_tree().get_nodes_in_group("XRCamera3D")[0]
	dialogue_node = get_parent()

func _physics_process(_delta: float) -> void:
	dialogue_node.look_at(xr_camera.global_position, Vector3.UP, true)

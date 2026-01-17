extends StaticBody3D

#@export var pickables: Array[XRToolsPickable]

var pickable_position_data: Dictionary = {} # XRToolsPickable : transform

func _ready() -> void:
	for item: XRToolsPickable in get_tree().get_nodes_in_group("Refreshable"):
		pickable_position_data[item] = item.global_transform

func _on_timer_timeout() -> void:
	for item: XRToolsPickable in get_tree().get_nodes_in_group("Refreshable"):
		if item.global_position.y < global_position.y:
			item.global_transform = pickable_position_data[item]
			item.linear_velocity = Vector3.ZERO
			item.angular_velocity = Vector3.ZERO
			if item.has_method("refresh"):
				item.refresh()

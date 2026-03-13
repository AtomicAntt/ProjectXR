@tool
class_name Food
extends XRToolsPickable

@onready var xr_camera: XRCamera3D = get_tree().get_nodes_in_group("XRCamera3D")[0]
@onready var player: Player = get_tree().get_nodes_in_group("Player")[0]

## Strictly a Node3Ds for a .glb. It must have a MeshInstance3D and a disabled CollisonShape3D in it (Which contains the collision shape).
## The index will be the stage of eating, and so every bite takes it to the next element of this array.
@export var eaten_meshes: Array[Node3D]

## The amount healed in each bite taken.
@export var heal_amount: int = 1

# The current stage the food is in. 0 means not eaten yet, 1 means a bite taken, and 2 means that two bites are taken.
var current_stage: int = 0

func _ready() -> void:
	super._ready()
	swap_stage(current_stage) # Reset in case things are off.

## Changes the collision shape of the food pickable given an index for the eaten_meshes so that collision shapes will change depending on the stage it's in.
func change_collision_shape(index: int) -> void:
	var collision_shape_3d: CollisionShape3D = eaten_meshes[index].get_node("CollisionShape3D")
	var shape_3d: Shape3D = collision_shape_3d.shape
	
	$CollisionShape3D.rotation = eaten_meshes[index].rotation # Lets also inherit their rotation in case lol
	$CollisionShape3D.shape = shape_3d

## This function should be called by player whenever a Food gets near the mouth of the player.
## Returns the amount healed.
func eat() -> int:
	eaten_meshes[current_stage].visible = false # Make invisible the previous stage of the food now that you ate it.
	current_stage += 1
	
	if eaten_meshes.size() <= current_stage:
		queue_free()
	else:
		swap_stage(current_stage)
	
	return heal_amount

## Finds the mesh_instance child in a Node3D. This is so we can replace the highlight.
func find_mesh_instance(node_3d: Node3D) -> MeshInstance3D:
	for child in node_3d.get_children():
		if child is MeshInstance3D:
			return child
	return null

## Updates the highlight mesh to a new MeshInstance3D that's given.
func change_highlight_mesh(new_mesh: MeshInstance3D) -> void:
	find_mesh_instance($XRToolsHighlightVisible).mesh = new_mesh.mesh
	$XRToolsHighlightVisible.rotation = new_mesh.get_parent().rotation

func swap_stage(stage: int) -> void:
	var current_stage_node: Node3D = eaten_meshes[stage]
	current_stage_node.visible = true
	change_collision_shape(stage)
	change_highlight_mesh(find_mesh_instance(current_stage_node))

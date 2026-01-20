@tool
class_name BottleCap
extends XRToolsPickable

func set_mesh(new_mesh: Mesh) -> void:
	$Cap.mesh = new_mesh

func set_material(new_material: Material) -> void:
	$Cap.material_override = new_material

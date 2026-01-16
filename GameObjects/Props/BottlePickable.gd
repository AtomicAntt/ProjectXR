@tool
extends XRToolsPickable

@export var bottle_cap: PackedScene

@onready var cap_mesh: MeshInstance3D = $Cap
@onready var open_sound: AudioStreamPlayer3D = $BottleOpen

func action() -> void:
	super.action()
	
	# No cap = bottle is opened already
	if not cap_mesh.visible:
		return
	
	var cap_instance: RigidBody3D = bottle_cap.instantiate()
	if cap_instance:
		cap_instance.set_as_top_level(true)
		add_child(cap_instance)
		cap_instance.global_transform = cap_mesh.global_transform
		cap_instance.apply_impulse(cap_mesh.global_transform.basis.y, cap_mesh.global_position - cap_mesh.global_transform.basis.y)
		cap_mesh.visible = false
		open_sound.play()

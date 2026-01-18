@tool
extends XRToolsPickable

@export var bottle_cap: PackedScene
@export var open_force: float = 3.0

## The largest angle between gravity and the object's orientation before spilling.
@export_range(0, 180) var angle_threshold: float = 90

@onready var cap_mesh: MeshInstance3D = $Cap
@onready var open_sound: AudioStreamPlayer3D = $BottleOpen

@onready var gravity_direction: Vector3 = Vector3.DOWN
@onready var threshold: float = cos(deg_to_rad(angle_threshold))

func refresh() -> void:
	cap_mesh.visible = true

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
		cap_instance.apply_impulse(cap_mesh.global_transform.basis.y * open_force, cap_mesh.global_position - cap_mesh.global_transform.basis.y)
		cap_mesh.visible = false
		open_sound.play()

var within_threshold: bool = false

func _physics_process(_delta: float) -> void:
	# returns the cos(theta) between the gravity vector and the object's local up vector
	# -1 represents that the object is upright (since the gravity vector should be 180 degrees from object)
	# 1 represents the object up direction and gravity direction are the same
	var angle_between: float = gravity_direction.dot(global_transform.basis.y)
	
	# make it more difficult to exit the pouring/not pouring state
	if within_threshold:
		angle_between -= 0.03
	else:
		angle_between += 0.03
	
	if angle_between <= threshold or cap_mesh.visible:
		# no spill
		within_threshold = true
		print("no spill")
	else: 
		# spill
		within_threshold = false
		print("spill")
	

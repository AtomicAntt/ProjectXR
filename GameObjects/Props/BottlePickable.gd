@tool
extends XRToolsPickable

@export var bottle_cap: PackedScene
@export var open_force: float = 3.0
@export var fill_amount: float = 0.5
@export var spill_speed: float = 0.3

## The largest angle between gravity and the object's orientation before spilling.
@export_range(0, 180) var angle_threshold: float = 90

@onready var cap_mesh: MeshInstance3D = $Cap
@onready var open_sound: AudioStreamPlayer3D = $BottleOpen

@onready var gravity_direction: Vector3 = Vector3.DOWN
@onready var threshold: float = cos(deg_to_rad(angle_threshold))

func _ready() -> void:
	set_fill(fill_amount)

func refresh() -> void:
	cap_mesh.visible = true
	fill_amount = 0.5
	set_fill(fill_amount)
	
func set_fill(amount: float) -> void:
	$Bottle.set_fill(amount)

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

# if within, then liquid will not spill.
var within_threshold: bool = true

func _physics_process(delta: float) -> void:
	# returns the cos(theta) between the gravity vector and the object's local up vector
	# -1 represents that the object is upright (180 degrees)
	# 0 represents object is sideways (90 degrees)
	# 1 represents the object is upsidedown (0 degrees)
	var angle_between: float = gravity_direction.dot(global_transform.basis.y)
	
	# make it more difficult to exit the pouring/not pouring state
	if within_threshold:
		angle_between -= 0.03
	else:
		angle_between += 0.03
	
	if angle_between <= threshold or cap_mesh.visible or fill_amount <= 0:
		# no spill
		within_threshold = true
	else: 
		# spill
		within_threshold = false
	
	if not within_threshold: # if spilling with liquid
		var spill_ratio: float = inverse_lerp(threshold, 1, angle_between)
		$GPUParticles3D.amount_ratio = spill_ratio
		if not Engine.is_editor_hint():
			fill_amount -= delta * spill_speed * spill_ratio
			clampf(fill_amount, 0, 1)
			set_fill(fill_amount)
	else:
		$GPUParticles3D.amount_ratio = 0

class_name Enemy
extends CharacterBody3D

enum States {
	IDLE, ## Enemy is in this state when they are doing nothing.
	CHARGING, ## Enemy is in this state when they are charging up some kind of attack.
	ATTACKING, ## Enemy is in this state when they are in the process of attacking.
	DEAD, ## Enemy is in this state when they die, and will soon despawn.
	HURT, ## Enemy is in this state when they are hit. Physics is enabled to show impact.
	WAITING ## Enemy is in this state after they get hit -> hurt OR if they are finished attacking. If all enemies are waiting, transition to player turn.
}
var state: States = States.IDLE

@onready var mesh_material: ShaderMaterial = $Slime/Sphere.material_overlay

@export var health: float = 100
@export var friction_speed: float = 10.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	match state:
		States.IDLE:
			# We do not want physics to be applied to an idle enemy.
			pass
		States.HURT: # HURT is a state that is completely cinematic, just to show an attack has done impact. Thus, physics shall be enabled.
			apply_gravity(delta)
			apply_friction(delta)
			move_and_slide()
		States.WAITING:
			pass

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

func apply_friction(delta: float) -> void:
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction_speed * delta)
		velocity.z = move_toward(velocity.z, 0, friction_speed * delta)

func set_hit_flash(value: float) -> void:
		mesh_material.set_shader_parameter("flash", value)
	
func set_hurt() -> void:
	state = States.HURT
	$RecoveryTimer.start()

func set_waiting() -> void:
	state = States.WAITING
	# Play transparency shader later
	visible = false

func hurt(damage_taken: float, new_velocity: Vector3 = Vector3.ZERO) -> void:
	if state != States.DEAD:
		health -= damage_taken
		mesh_material.set_shader_parameter("flash", 1.0)
		var tween: Tween = create_tween()
		tween.tween_method(set_hit_flash, 1.0, 0.0, 0.5)
		
		velocity = new_velocity
		set_hurt()
		
		if health <= 0:
			death()

func death() -> void:
	state = States.DEAD

func _on_recovery_timer_timeout() -> void:
	set_waiting()

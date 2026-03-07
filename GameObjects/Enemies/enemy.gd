class_name Enemy
extends CharacterBody3D

enum States {
	IDLE, ## Enemy is in this state when they are doing nothing.
	CHARGING, ## Enemy is in this state when they are charging up some kind of attack.
	ATTACKING, ## Enemy is in this state when they are in the process of attacking.
	DEAD, ## Enemy is in this state when they die, and will soon despawn.
	HURT, ## Enemy is in this state when they are hit. Physics is enabled to show impact.
	WAITING ## During an enemy turn, enemies will be in this state after they get hit -> hurt OR if they are finished attacking. If all enemies are waiting, transition to player turn.
}
var state: States = States.IDLE

@onready var flash_material: ShaderMaterial = $Slime/Sphere.material_overlay
@onready var dither_material: ShaderMaterial = $Slime/Sphere.material_override
@onready var health_bar_3d: HealthBar3D = $HealthBar3D

@export var health: float = 100
@export var friction_speed: float = 5.0

var disappear_tween: Tween

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	match state:
		States.IDLE:
			# We do not want physics to be applied to an idle enemy.
			$StateLabel.text = "IDLE"
		States.HURT: # HURT is a state that is completely cinematic, just to show an attack has done impact. Thus, physics shall be enabled.
			apply_gravity(delta)
			apply_friction(delta)
			move_and_slide()
			$StateLabel.text = "HURT"
		States.WAITING:
			$StateLabel.text = "WAITING"
		States.CHARGING:
			$StateLabel.text = "CHARGING"
		States.ATTACKING:
			apply_gravity(delta)
			apply_friction(delta)
			move_and_slide()
			$StateLabel.text = "ATTACKING"
		States.DEAD:
			$StateLabel.text = "DEAD"

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

func apply_friction(delta: float) -> void:
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction_speed * delta)
		velocity.z = move_toward(velocity.z, 0, friction_speed * delta)

func set_hit_flash(value: float) -> void:
	flash_material.set_shader_parameter("flash", value)

func set_dither_alpha(value: float) -> void:
	dither_material.set_shader_parameter("color_alpha", value)
	
func set_hurt() -> void:
	state = States.HURT
	$RecoveryTimer.start()

func set_idle() -> void:
	state = States.IDLE

## This function should be called by the CombatLevel whenever on_enemy_recovered() occurs during the enemy's turn.
## Player hits enemy -> hurt state + recovery timer starts -> recovery timer ends -> recover() emits global signal
## -> on_enemy_recovered() called -> if it is enemy turn, this gets called.
func set_waiting() -> void:
	state = States.WAITING
	
	# If deemed uneeded, remove this:
	#disappear_tween = create_tween()
	#disappear_tween.tween_method(set_dither_alpha, 1.0, 0.0, 0.3)
	#await disappear_tween.finished
	#visible = false
	
	# This is required to let the CombatLevel check if all enemies are waiting. If they are, then it can become the player's turn.
	Global.emit_enemy_waiting()

## This function is likely called by a combat level script. Use it on enemies that are is_idle() at the start of an enemy turn.
## It starts the ChargeTimer, which when ended, will set the enemy to the attacking state so that they can launch their attack.
func set_charging() -> void:
	state = States.CHARGING
	$ChargeTimer.start()

## Once a charge is complete (ChargeTimer is completed), this function should be called. It will send the enemy into an attacking state.
## Enemies in attacking state can be attacked by the player, and the purpose is so that they don't get taken into a charging state.
## Conditions like hitting the player, getting hit, hitting the floor, or a timer should set them back into idle/hurt/waiting mode to be used again.
## How this condition gets set is likely to be done by the class inheriting from this class.
func set_attacking() -> void:
	state = States.ATTACKING

func is_waiting() -> bool:
	return state == States.WAITING

## Probably used to find out if an enemy can be turned charging during an enemy turn.
func is_idle() -> bool:
	return state == States.IDLE

func hurt(damage_taken: float, new_velocity: Vector3 = Vector3.ZERO) -> void:
	if state != States.DEAD:
		health -= damage_taken
		health_bar_3d.set_value(health)
		flash_material.set_shader_parameter("flash", 1.0)
		var tween: Tween = create_tween()
		tween.tween_method(set_hit_flash, 1.0, 0.0, 0.5)
		
		velocity = new_velocity
		set_hurt()
		
		#if health <= 0:
			#death()

#func death() -> void:
	#state = States.DEAD

func is_dead() -> bool:
	return state == States.DEAD

func reappear() -> void:
	visible = true
	disappear_tween = create_tween()
	disappear_tween.tween_method(set_dither_alpha, 0.0, 1.0, 0.3)

# After getting hurt, recover by disappearing until its time to spawn back on either the player's turn or an enemy's turn
func recover() -> void:
	disappear_tween = create_tween()
	disappear_tween.tween_method(set_dither_alpha, 1.0, 0.0, 0.3)
	await disappear_tween.finished
	visible = false
	
	if health <= 0:
		# Only once they recover, they realize they are dead, actually.
		state = States.DEAD
		queue_free()
	
	# If the enemy was recovers during a player's turn, transition to the enemy turn.
	# If the enemy was recovers during the enemy's turn, set state to waiting.
	# Well, lets just hope that whoever receives the enemy recovered signal applies the above logic.
	Global.emit_enemy_recovered(self)

func _on_recovery_timer_timeout() -> void:
	recover()

func _on_charge_timer_timeout() -> void:
	set_attacking()

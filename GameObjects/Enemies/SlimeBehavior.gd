class_name SlimeBehavior
extends Enemy

@onready var xr_camera: XRCamera3D = get_tree().get_nodes_in_group("XRCamera3D")[0]

## The time, in seconds, for this enemy to reach the player after attacking them
@export var time_to_enemy: float

#func _physics_process(_delta: float) -> void:
	#if state != States.DEAD and state != States.HURT:
		#look_at(Vector3(xr_camera.global_position.x, 0, xr_camera.global_position.z))

func set_attacking() -> void:
	super.set_attacking()
	velocity = calculate_velocity()
	
	$SlimeAttackTimer.wait_time = time_to_enemy + 1
	$SlimeAttackTimer.start()

func calculate_velocity() -> Vector3:
	var horizontal_position: Vector3 = Vector3(global_position.x, 0, global_position.z)
	var player_horizontal_position: Vector3 = Vector3(xr_camera.global_position.x, 0, xr_camera.global_position.z)
	var horizontal_distance: float = horizontal_position.distance_to(player_horizontal_position)
	
	var vertical_distance: float = xr_camera.global_position.y - global_position.y
	
	var horizontal_speed: float = horizontal_distance/time_to_enemy
	var vertical_velocity: float = (vertical_distance - ((0.5) * (-gravity) * pow(time_to_enemy, 2)))/time_to_enemy
	
	var horizontal_velocity: Vector3 = horizontal_position.direction_to(player_horizontal_position) * horizontal_speed
	
	return Vector3(horizontal_velocity.x, vertical_velocity, horizontal_velocity.z)

func _on_attack_timer_timeout() -> void:
	if state == States.ATTACKING:
		recover()

@tool
extends XRToolsPickable

var can_fire: bool = true

@export var bullet: PackedScene
@export var bullet_speed: float = 10.0

func action() -> void:
	super.action()
	
	if can_fire:
		spawn_bullet()
		can_fire = false
		$Cooldown.start()
		if is_instance_valid(_grab_driver):
			$Shoot.rumble_hand(_grab_driver.primary.controller)

func spawn_bullet():
	if bullet:
		var bullet_instance: RigidBody3D = bullet.instantiate()
		if bullet_instance:
			bullet_instance.set_as_top_level(true)
			add_child(bullet_instance)
			bullet_instance.transform = $SpawnPoint.global_transform
			bullet_instance.linear_velocity = bullet_instance.transform.basis.z * bullet_speed
			$SteamAudioPlayer.play()

func _on_cooldown_timeout() -> void:
	can_fire = true

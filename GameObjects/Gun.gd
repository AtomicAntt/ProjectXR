@tool
extends XRToolsPickable

var can_fire: bool = true

func action() -> void:
	super.action()
	
	if can_fire:
		spawn_bullet()
		can_fire = false
		$Cooldown.start()
		if is_instance_valid(_grab_driver):
			$Shoot.rumble_hand(_grab_driver.primary.controller)

func spawn_bullet():
	pass

func _on_cooldown_timeout() -> void:
	can_fire = true

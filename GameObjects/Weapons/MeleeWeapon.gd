@tool
class_name MeleeWeapon
extends XRToolsPickable

func _on_hitbox_body_entered(body: Node3D) -> void:
	if is_picked_up() and body.is_in_group("Enemy"):
		if _grab_driver.primary.controller:
			var enemy: Enemy = body
			var xr_controller: XRController3D = _grab_driver.primary.controller
			var xr_linear_velocity: Vector3 = xr_controller.get_pose().linear_velocity
			var xr_angular_velocity: Vector3 = xr_controller.get_pose().angular_velocity
			var xr_linear_magnitude: float = xr_linear_velocity.length()
			var xr_angular_magnitude: float = xr_angular_velocity.length()
			
			get_node("DebugLabel").text = "lv: " + str(xr_linear_velocity.snapped(Vector3(0.1, 0.1, 0.1))) + "," + str(snapped(xr_linear_magnitude, 0.01))
			get_node("DebugLabel2").text = "av: " + str(xr_angular_velocity.snapped(Vector3(0.1, 0.1, 0.1))) + "," + str(snapped(xr_angular_magnitude, 0.01))
			
			if (xr_linear_magnitude >= 1.0) or (xr_angular_magnitude >= 1.0):
				var rumbler: XRToolsRumbleEvent = $ImpactRumbler.event
				rumbler.magnitude = clampf(((xr_angular_magnitude/2) + (xr_linear_magnitude/2))/25, 0.0, 1.0)
				$ImpactRumbler.rumble_hand(_grab_driver.primary.controller)
				enemy.hurt(0)

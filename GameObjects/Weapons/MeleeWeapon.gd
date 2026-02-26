@tool
class_name MeleeWeapon
extends XRToolsPickable

func _on_hitbox_body_entered(body: Node3D) -> void:
	if is_picked_up() and body.is_in_group("Enemy"):
		if _grab_driver.primary.controller:
			var xr_controller: XRController3D = _grab_driver.primary.controller
			print("Linear velocity on impact: " + str(xr_controller.get_pose().linear_velocity))
			print("Angular velocity on impact: " + str(xr_controller.get_pose().angular_velocity))

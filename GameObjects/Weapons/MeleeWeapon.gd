@tool
class_name MeleeWeapon
extends XRToolsPickable

func _on_hitbox_body_entered(body: Node3D) -> void:
	if is_picked_up() and body.is_in_group("Enemy"):
		if _grab_driver.primary.controller:
			var xr_controller: XRController3D = _grab_driver.primary.controller
			var xr_linear_velocity: Vector3 = xr_controller.get_pose().linear_velocity
			var xr_angular_velocity: Vector3 = xr_controller.get_pose().angular_velocity
			#print("Linear velocity on impact: " + str(xr_linear_velocity))
			#print("Linear velocity magnitude: " + str(xr_linear_velocity.length()))
			#print("Angular velocity on impact: " + str(xr_angular_velocity))
			#print("Angular velocity magnitude: " + str(xr_angular_velocity.length()))
			
			get_node("DebugLabel").text = "lv: " + str(xr_linear_velocity.snapped(Vector3(0.1, 0.1, 0.1))) + "," + str(snapped(xr_linear_velocity.length(), 0.01))
			get_node("DebugLabel2").text = "lv: " + str(xr_angular_velocity.snapped(Vector3(0.1, 0.1, 0.1))) + "," + str(snapped(xr_angular_velocity.length(), 0.01))
			
			
			

extends Node3D

@onready var hitbox: Area3D = $Area3D
@onready var original_pos: Vector3 = hitbox.global_position

func _on_area_3d_body_entered(body: Node3D) -> void:
	body.queue_free()
	
	hitbox.global_position = original_pos + Vector3(randf_range(-3.0, 3.0), randf_range(-1.0, 1.0), 0)
	$SteamAudioPlayer.play()

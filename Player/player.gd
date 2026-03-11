class_name Player
extends XROrigin3D

var lives: int = 5
var max_lives: int = lives

func _ready() -> void:
	$RightHand/LivesLeft.text = str(lives) + " HP"

func hurt(damage: int = 1) -> void:
	lives -= damage
	$RightHand/LivesLeft.text = str(lives) + " HP"
	
	if damage > 0:
		$XRCamera3D/HurtVignette.play_effect()
	else:
		$XRCamera3D/HealVignette.play_effect()

@warning_ignore("shadowed_variable_base_class")
func _on_trigger_button_pressed(name: String) -> void:
	if name == "trigger_click":
		get_tree().call_group("DialogueText2D", "proceed_dialogue")
	
func _process(_delta: float) -> void:
	$LeftHand/FPSLabel.text = str(Engine.get_frames_per_second())

func _on_left_function_pickup_has_hover_entered_ranged(what: Variant) -> void:
	$LeftHand/PickupIndicator.visible = true
	$LeftHand/PickupIndicator.start(what)

func _on_right_function_pickup_has_hover_entered_ranged(what: Variant) -> void:
	$RightHand/PickupIndicator.visible = true
	$RightHand/PickupIndicator.start(what)

func _on_left_function_pickup_has_hover_exited() -> void:
	$LeftHand/PickupIndicator.visible = false
	$LeftHand/PickupIndicator.stop()

func _on_right_function_pickup_has_hover_exited() -> void:
	$RightHand/PickupIndicator.visible = false
	$RightHand/PickupIndicator.stop()

func _on_player_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("EnemyAttack"):
		hurt()

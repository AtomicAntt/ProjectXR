class_name Enemy
extends CharacterBody3D

enum States {IDLE, CHARGING, ATTACKING, DEAD}
var state: States = States.IDLE

@export var health: float = 100

func hurt(damage_taken: float) -> void:
	if state != States.DEAD:
		health -= damage_taken
		if health <= 0:
			death()

func death() -> void:
	state = States.DEAD

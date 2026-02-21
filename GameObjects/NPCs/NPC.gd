class_name NPC
extends Node3D

func pointer_event(event: XRToolsPointerEvent) -> void:
	if event.event_type == event.Type.PRESSED:
		print("Hello world!")

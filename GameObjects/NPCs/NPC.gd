class_name NPC
extends Node3D

@onready var dialogue_marker = $DialogueMarker3D
@export_file_path("*.json") var dialogue_directory: String
var dialogue_container: PackedScene = preload("res://UI/Dialogue/DialogueContainer3D.tscn")

func pointer_event(event: XRToolsPointerEvent) -> void:
	if event.event_type == event.Type.PRESSED:
		if get_tree().get_node_count_in_group("DialogueContainer") == 0:
			var dialogue_container_instance: DialogueContainer = dialogue_container.instantiate()
			get_parent().add_child(dialogue_container_instance)
			dialogue_container_instance.global_position = dialogue_marker.global_position
			dialogue_container_instance.parse_json_data(dialogue_directory)
			dialogue_container_instance.write_text()

extends Node

@export var world: Node3D
@export var level_instance: Node3D

@onready var fade: Fade = get_tree().get_first_node_in_group("Fade")

var current_scene: String

func _ready() -> void:
	Global.transition_scene.connect(transition_level)

func unload_level() -> void:
	if is_instance_valid(level_instance):
		level_instance.queue_free()
	level_instance = null

func load_level(level_name: String) -> void:
	unload_level()
	
	var level_path: String = "res://Levels/%s.tscn" % level_name
	var level_resource: Resource = load(level_path)
	
	if level_resource:
		level_instance = level_resource.instantiate()
		world.add_child(level_instance)
	
	current_scene = level_name

func transition_level(level_name: String) -> void:
	fade.fade_in()
	await fade.fade_in_complete
	load_level(level_name)
	await get_tree().create_timer(1.0).timeout
	fade.fade_out()

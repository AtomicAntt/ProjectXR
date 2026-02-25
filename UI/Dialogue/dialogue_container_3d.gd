class_name DialogueContainer
extends Node3D

var dialogue_choice3D: PackedScene = preload("res://UI/Dialogue/DialogueChoice3D.tscn")

@onready var dialogue_text: Dialogue3D = $DialogueText
@onready var dialogue_text_2d: DialogueText2D = dialogue_text.get_scene_instance()

## Offset between the dialogue text and the first option UI (if any)
@export var text_offset: float = 0.4

## Offset between the option UI themselves
@export var choice_offset: float = 0.25

## This value should be given by a JSON file, containing an array of dictionaries containing dialogue data.
var dialogue_data: Array

## This value should be set by the JSON file. It will specify whether the dialogue would end after the user proceeds dialogue. 
## If this is false, then the next index of the dialogue data JSON will be used once dialogue continues.
var end: bool = true

## The current index to know which dialogue data to display.
var current_index: int = 0

func parse_json_data(json_directory: String):
	var file := FileAccess.get_file_as_string(json_directory)
	dialogue_data = JSON.parse_string(file)
	
	process_data(0)

func _ready() -> void:
	Global.goto_action.connect(goto)
	Global.confirm_dialogue.connect(load_next_text)
	dialogue_text_2d.text_completed.connect(show_options)
	#add_option("Yo, teleport me", {})
	#add_option("JK", {})
	parse_json_data("res://UI/Data/GameSystemDialogue.json")
	write_text()

func set_text(new_text: String) -> void:
	dialogue_text_2d.set_text(new_text)

func write_text() -> void:
	dialogue_text_2d.write_text()

func get_text() -> String:
	return dialogue_text_2d.get_text()

## This function should be connected to the global signal, goto, which is called whenever a 2D button/choice has to call.
func goto(index: int) -> void:
	current_index = index

# Adds the actual 3D option UI button and initialize properties for the 2D UI button within it.
# Initially, these options will be invisible and you must call show_options() to display them.
# This is because dialogue text must be completed before the player can choose an option.
func add_option(text: String, functions: Dictionary) -> void:
	var dialogue_choice3D_instance: Dialogue3D = dialogue_choice3D.instantiate()
	add_child(dialogue_choice3D_instance)
	dialogue_choice3D_instance.global_position = dialogue_text.global_position - Vector3(0, ((get_tree().get_node_count_in_group("DialogueChoice")-1)*choice_offset) + text_offset, 0)
	
	var dialogue_choice2D: DialogueButton2D = dialogue_choice3D_instance.get_scene_instance()
	dialogue_choice2D.set_text(text)
	dialogue_choice2D.set_functions(functions)
	
	dialogue_choice3D_instance.visible = false
	dialogue_choice3D_instance.enabled = false

# This function is part of the cleanup and should be called before processing new data from the JSON parsed data.
func remove_options() -> void:
	for node in get_children():
		if node.is_in_group("DialogueChoice"):
			node.remove_from_group("DialogueChoice") # This is to prevent an issue relating to adding new dialogues under these dialogues about to be removed.
			node.queue_free()

# This function should be called after all the text is completed so you can select an option.
func show_options() -> void:
	for node in get_children():
		if node.is_in_group("DialogueChoice"):
			var dialogue_choice: Dialogue3D = node
			dialogue_choice.visible = true
			dialogue_choice.enabled = true

## Adds the text to the dialogue, adds the options, and tracks if dialogue would end once interacted with.
func process_data(index: int) -> void:
	remove_options()
	var processing_data: Dictionary = dialogue_data[index]
	
	set_text(processing_data["text"])
	for option: Dictionary in processing_data["options"]:
		add_option(option["text"], option["functions"])
	end = processing_data["end"]

## Call this either after a dialogue is continued (no dialogue choices given) or a dialogue choice is given and all the functions given are called.
func load_next_text() -> void:
	if end:
		queue_free()
		return
	
	# let us hope that any goto functions have changed this by the time this happens
	process_data(current_index)
	write_text()
	
	# We will now be ready for the next text to be loaded
	current_index += 1
	

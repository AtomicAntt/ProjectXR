@tool
class_name ItemSlot
extends XRToolsSnapZone

# Huge thanks to this. Some logic converted from C# to GDScript.
# Unfortunately, the code I wrote currently is not working as intended.
# https://github.com/AbstractBorderStudio/energy-shield-shader-with-impact-effect

@export var mAnimCurve: Curve
@export var mImpactCurve: Curve

@export var mAnimTime: float = 1.0
var mElapsedTime: float = 0.0
@onready var mMaterial: ShaderMaterial = $MeshInstance3D.material_override

var mAnimate = false

## Radius of the shader, manually set this to the mesh's radius.
@export var slot_radius: float = 0.1

## Current item that is getting dragged.
## This should be set whenever a ReturnItemTimer ends and an item can be dragged.
## Set this back to null if an item is already grabbed, obviously.
var item_dragging: XRToolsPickable = null
var drag_tween: Tween
@export var drag_time: float = 0.5
#@export var drag_speed: float = 50.0


func set_impact_origin(pos: Vector3) -> void:
	#print("impact origin is set at" + str(pos))
	
	# Reset animation
	mMaterial.set_shader_parameter("_impact_origin", pos)
	mMaterial.set_shader_parameter("_impact_anim", 0.0)
	mAnimate = true
	mElapsedTime = 0.0

func _on_body_entered(body: Node3D) -> void:
	var position_hit: Vector3 = global_position + global_position.direction_to(body.global_position) * slot_radius
	set_impact_origin(position_hit)
	
func _on_body_exited(body: Node3D) -> void:
	var position_hit: Vector3 = global_position + global_position.direction_to(body.global_position) * slot_radius
	set_impact_origin(position_hit)
	
func tool_hit_random() -> void:
	var random_pos = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized() * slot_radius
	set_impact_origin(random_pos)

@export_tool_button("Start") var start_emit = tool_hit_random

## Returns an item that is in the Snap Require group out there in the world.
## Purpose is so that you can get the item back or into this slot when possible.
## Call this after a ReturnItemTimer ends so that an item can get dragged.
func retrieve_valid_object() -> XRToolsPickable:
	for item: XRToolsPickable in get_tree().get_nodes_in_group(snap_require):
		if not is_item_dragged(item) and not item.is_picked_up() and is_instance_valid(item):
			return item
	return null

## Checks if any other item slot is already dragging the specific item given as an argument.
## Purpose is that when the return item timer runs out, we want to start dragging the item closer to this item slot
## but we don't want to fight with other item slots.
func is_item_dragged(item: XRToolsPickable) -> bool:
	for item_slot: ItemSlot in get_tree().get_nodes_in_group("ItemSlot"):
		if item_slot.item_dragging == item:
			return true
	return false

func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if not is_instance_valid(picked_up_object) and $ReturnItemTimer.is_stopped() and not is_instance_valid(item_dragging):
			# If we don't have anything picked up, we start the return item timer (if not already) so that it will see if it can start dragging.
			# Additionally, we aren't already dragging an item.
			$ReturnItemTimer.start()
		elif not is_instance_valid(picked_up_object) and is_instance_valid(item_dragging):
			if item_dragging.is_picked_up(): # Extra shield of protection
				## If we haven't picked up anything yet, and there's an item to drag that isn't already picked up.
				#item_dragging.global_position.move_toward(global_position, drag_speed * delta)
			#else:
				stop_item_dragging()
		elif is_instance_valid(picked_up_object):
			# We already have something, so don't drag anything.
			stop_item_dragging()
			
			# Also, for the purpose of possibly hiding this item slot during enemy turns, let picked up objects share visiblity
			picked_up_object.visible = visible
	
	if mAnimate:
		if mElapsedTime < mAnimTime:
			var normalize_time: float = mElapsedTime / mAnimTime
			mMaterial.set_shader_parameter("_impact_blend", mAnimCurve.sample(normalize_time))
			mMaterial.set_shader_parameter("_impact_anim", mImpactCurve.sample(normalize_time))
			mElapsedTime += delta
		else:
			mMaterial.set_shader_parameter("_impact_blend", 0.0)
			mMaterial.set_shader_parameter("_impact_anim", 0.0)
			
			mElapsedTime = 0.0
			mAnimate = false

func stop_item_dragging() -> void:
	item_dragging = null
	if is_instance_valid(drag_tween):
		drag_tween.stop()

## This function's purpose is to grab any items being dragged when it becomes the enemy's turn.
func instant_grab() -> void:
	if not is_instance_valid(item_dragging):
		retrieve_valid_object()
	else:
		pick_up_object(item_dragging)
		stop_item_dragging()

func _on_return_item_timeout() -> void:
	item_dragging = retrieve_valid_object()
	if is_instance_valid(item_dragging):
		drag_tween = create_tween()
		drag_tween.tween_property(item_dragging, "global_position", global_position, drag_time)
		drag_tween.parallel().tween_property(item_dragging, "global_rotation", Vector3.ZERO, drag_time)
		

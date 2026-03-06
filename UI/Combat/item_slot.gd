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

func _physics_process(delta: float) -> void:
	#if not Engine.is_editor_hint():
	if mAnimate:
		if mElapsedTime < mAnimTime:
			var normalize_time: float = mElapsedTime / mAnimTime
			mMaterial.set_shader_parameter("_impact_blend", mAnimCurve.sample(normalize_time))
			mMaterial.set_shader_parameter("_impact_anim", mImpactCurve.sample(normalize_time))
			#mMaterial.set_shader_parameter("_shield_intensity", normalize_time*2)
			mElapsedTime += delta
		else:
			mMaterial.set_shader_parameter("_impact_blend", 0.0)
			mMaterial.set_shader_parameter("_impact_anim", 0.0)
			#mMaterial.set_shader_parameter("_shield_intensity", 2.0)
			
			mElapsedTime = 0.0
			mAnimate = false
		
		#var impact_blend = mMaterial.get_shader_parameter("_impact_blend")
		#var impact_anim = mMaterial.get_shader_parameter("_impact_anim")
		#var current_origin = mMaterial.get_shader_parameter("_impact_origin")
		
		#print("Impact_Blend value: " + str(impact_blend) + ", Impact_Anim value: " + str(impact_anim) + ", At: " + str(current_origin))

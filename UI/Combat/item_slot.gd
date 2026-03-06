@tool
class_name ItemSlot
extends XRToolsSnapZone

# Huge thanks to this. Some logic converted from C# to GDScript.
# https://github.com/AbstractBorderStudio/energy-shield-shader-with-impact-effect

@export var mAnimCurve: Curve
@export var mImpactCurve: Curve

@export var mAnimTime: float = 1.0
@onready var mMaterial: ShaderMaterial = $MeshInstance3D.get_surface_override_material(0)

var tween: Tween = create_tween()

## Radius of the shader, manually set this to the mesh's radius.
@export var slot_radius: float = 0.1

func set_impact_origin(pos: Vector3) -> void:
	# Reset animation
	mMaterial.set_shader_parameter("_impact_origin", pos)
	mMaterial.set_shader_parameter("_impact_anim", 0.0)
	
	# Play animation
	tween.stop()
	tween.tween_method(animate_shader, 0.0, mAnimTime, mAnimTime)

func animate_shader(progress: float) -> void:
	var normalize_time = progress / mAnimTime
	mMaterial.set_shader_parameter("_impact_blend", mAnimCurve.sample(normalize_time))
	mMaterial.set_shader_parameter("_impact_anim", mImpactCurve.sample(normalize_time))

func _on_body_entered(body: Node3D) -> void:
	var position_hit: Vector3 = global_position + (global_position.direction_to(body.global_position) * slot_radius)
	set_impact_origin(position_hit)

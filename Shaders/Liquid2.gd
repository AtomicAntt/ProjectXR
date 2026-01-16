@tool
extends MeshInstance3D

@export var fill_amount : float

@export var glass_color : Color 
@export var glass_glow_color : Color

@export var glass_thickness : float 

@export var liquid_color : Color 
@export var liquid_glow_color : Color

@export var container_height : float 
@export var container_width : float 

@export var wave_intensity : float

@export var bottle_label : Texture

@export var dampening : float = 3.0
@export var spring_constant : float = 200.0
@export var reaction : float = 4.0

@export var liquidShaderMaterial: ShaderMaterial
@export var liquidShaderMaterial2: ShaderMaterial

var coeff : Vector2
var coeff_old : Vector2
var coeff_old_old : Vector2

@onready var pos : Vector3 = to_global(position)
@onready var pos_old : Vector3 = pos
@onready var pos_old_old : Vector3 = pos_old

@onready var material_pass_1
@onready var material_pass_2
@onready var material_pass_3
@onready var material_pass_4

var accell : Vector2

func _physics_process(delta):
	var accell_3d = (pos - 2 * pos_old + pos_old_old) / delta / delta
	pos_old_old = pos_old
	pos_old = pos
	pos = global_position

	accell = Vector2(accell_3d.x, accell_3d.z)

	coeff_old_old = coeff_old
	coeff_old = coeff
	coeff = delta*delta* (-spring_constant*coeff_old - reaction*accell) + 2 * coeff_old - coeff_old_old - delta * dampening * (coeff_old - coeff_old_old)

	liquidShaderMaterial.set_shader_param("coeff", coeff)
	liquidShaderMaterial2.set_shader_param("coeff", coeff)

	liquidShaderMaterial.set_shader_param("vel", (coeff - coeff_old) / delta)

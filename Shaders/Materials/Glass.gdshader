shader_type spatial;
render_mode cull_disabled;

uniform float AlphaAmount: hint_range(0.0, 1.0, 0.001) = 0.5;
uniform float Metallic: hint_range(0.0, 1.0, 0.001) = 0.5;
uniform float Roughness: hint_range(0.0, 1.0, 0.001) = 0.5;
uniform float Rim: hint_range(0.0, 1.0, 0.001) = 0.5;
uniform float RimTint: hint_range(0.0, 1.0, 0.001) = 0.5;
uniform float Specular: hint_range(0.0, 1.0, 0.001) = 0.5;

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

void fragment() {
	float basic_fresnel = fresnel(3.0, NORMAL, VIEW);
	ALBEDO = vec3(0.1) + basic_fresnel;
	ALPHA     = AlphaAmount;
	METALLIC  = Metallic;
	ROUGHNESS = Roughness;
	SPECULAR  = Specular;
	RIM       = Rim;
	RIM_TINT  = RimTint;
}
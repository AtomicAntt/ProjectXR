shader_type spatial;

const vec3 ign = vec3(0.06711056f, 0.00583715f, 52.9829189f);
uniform vec3 color: source_color = vec3(1.0, 1.0, 1.0);
uniform float color_alpha: hint_range(0.0, 1.0) = 1.0;
uniform sampler2D base_texture : source_color;

void fragment() {
	vec4 tex = texture(base_texture, UV);
	
	ALBEDO = mix(tex.rgb, color.rgb, 0.0);
	if (color_alpha < 0.001 || color_alpha < fract(ign.z * fract(dot(FRAGCOORD.xy, ign.xy)))) {
		discard;
	}
}

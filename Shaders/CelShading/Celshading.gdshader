shader_type spatial;
render_mode blend_mix, depth_draw_opaque, diffuse_toon, specular_toon;

uniform vec4 albedo : source_color;
uniform sampler2D color_gradient;

void fragment() {
	ALBEDO = albedo.rgb;
}

void light() {
	float dotproduct = clamp(dot(NORMAL, LIGHT), -0.9, 0.9);
	float sample = clamp((dotproduct + 1.0) * ATTENUATION / 2.1, 0.05, 0.95);
	vec4 shaded = texture(color_gradient, vec2(sample, 0.0));
	DIFFUSE_LIGHT += clamp((shaded.rgb * LIGHT_COLOR), 0.0, 1.0);
}

//void light(){
	//float nDotL = clamp(dot(NORMAL, LIGHT), 0.0, 1.0);
	//nDotL = smoothstep(0.01, 0.1, nDotL); // Add smoothstep
	//vec3 result = vec3(nDotL);
	//DIFFUSE_LIGHT += result;
//}
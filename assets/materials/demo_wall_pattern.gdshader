shader_type spatial;
uniform sampler2D pattern_texture;
uniform sampler2D logo_texture;
instance uniform bool show_logo = true;
uniform bool mirror_logo = true;
instance uniform vec4 color1 : source_color = vec4(0.4666, 0.4666, 0.4666, 1.0);
instance uniform vec4 color2 : source_color = vec4(0.50588, 0.50588, 0.50588, 1.0);
instance uniform vec4 logo_color : source_color  = vec4(0.0, 0.4862, 0.7960, 1.0);
instance uniform float roughness0 = 0.3;
instance uniform float roughness1 = 0.674477;
instance uniform float roughness2 = 0.289606;
instance uniform float metallic = 0.56397;
instance uniform float scale = 13.35;

void fragment() {
	vec2 logo_uv;
	if (mirror_logo) {
		logo_uv = UV * vec2(-1.0, 1.0);
	} else {
		logo_uv = UV * vec2(1.0, 1.0);
	}
	vec4 logo_sampling = texture(logo_texture, logo_uv);
	if (show_logo) {
		EMISSION = mix(vec4(0.0), logo_color, logo_sampling.r).xyz * 5.0;
	}
	
	vec4 pattern_sampling = texture(pattern_texture, UV * scale);
	vec3 color = mix(color1, color2, pattern_sampling.b).xyz;
	if (show_logo) {
		ALBEDO = mix(color, vec3(0.0), logo_sampling.r);
	} else {
		ALBEDO = color;
	}
	METALLIC = metallic;
	float r = mix(roughness0, roughness1, pattern_sampling.r);
	ROUGHNESS = mix(r, roughness2, pattern_sampling.g);
	AO = 1.0;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}

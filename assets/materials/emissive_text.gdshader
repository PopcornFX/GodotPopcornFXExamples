shader_type spatial;

// TODO / not working yet

uniform vec4 albedo : source_color = vec4(0.5, 0.5, 0.5, 1.0);
uniform vec4 emissive : source_color = vec4(0.5, 0.5, 0.5, 1.0);
render_mode blend_add;
render_mode cull_disabled;
render_mode ambient_light_disabled;
//render_mode shadows_disabled;
//render_mode shadow_to_opacity;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALPHA = COLOR.r;
	EMISSION = emissive.xyz * 3.5;// * UV.x;
	ALBEDO = albedo.xyz;
	AO = 0.5;
	ALPHA_SCISSOR_THRESHOLD = 0.701;
	if (COLOR.b > 0.0) {
		//ALBEDO = albedo.xyz;
		//ALBEDO = COLOR.xyz;
		//ALPHA = COLOR.a;
	} else {
		//ALPHA = 0.0;
		//ALBEDO = vec3(0.0);
		//EMISSION = vec3(0.0);
	}
}

void light () {
	//DIFFUSE_LIGHT += ALBEDO.xyz;
}

shader_type canvas_item;
uniform bool whiten = false;
uniform float mix_weight = 1.0;

varying flat vec4 modulate;

void vertex() {
	modulate = COLOR;
}

void fragment() {
	vec4 texture_color = texture(TEXTURE,UV);

	vec3 white = vec3(1,1,1);
	vec3 whitened_texture_rgb = mix(texture_color.rgb,white, mix_weight);
	COLOR = vec4(whitened_texture_rgb, texture_color.a);
	COLOR.a *= modulate.a;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

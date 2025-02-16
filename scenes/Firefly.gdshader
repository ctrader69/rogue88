shader_type canvas_item;

void fragment() {
	vec3 sc = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
	vec4 tc = texture(TEXTURE, UV);
	COLOR.rgb = mix(sc, vec3(0.67, 1.0, 0.0), tc.r / 4.0);
}
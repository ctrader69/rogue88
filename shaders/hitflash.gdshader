shader_type canvas_item;

uniform bool flash = false;

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	if (flash) {
		vec4 c_flash = vec4(1.0, 1.0, 1.0, c.a); // red
		COLOR = c_flash;
	} else {
		COLOR = c;
	}
}
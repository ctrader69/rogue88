shader_type canvas_item;
uniform float freq = 1.0;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.b = abs(sin(TIME * freq)) * 1.0 * COLOR.a;
}

shader_type canvas_item;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.r = 0.0;
	COLOR.g = 1.0;
	COLOR.b = 0.0;
}

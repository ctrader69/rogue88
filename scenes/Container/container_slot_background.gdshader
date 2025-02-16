shader_type canvas_item;
uniform float selected = 0.;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.r = 0.0;
	COLOR.g = COLOR.a * selected;
	COLOR.b = 0.0;
	COLOR.a = 0.2;
}

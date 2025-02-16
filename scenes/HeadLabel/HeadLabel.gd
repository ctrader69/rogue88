extends Node2D

# TODO: font autoload
# TODO: child class (HitLabel, HealLabel, ... that sets standard colors)
# TODO: handle scale (start/end position should also be scaled)
# TODO: position should be center,bottom coord of labelfire
# TODO: kerning info for +/-<number>

const TEXT_STRIDE = 4
const LIFE = 1.0

func _ready():
	# GODOT_4 - font
#	var font = FontFile.new()
#	font.add_texture(load("res://assets/font.png"))
#	font.height = 6
#	var offset = 0
#	for c in range(32, 122):
#		font.add_char(c, 0, Rect2(offset, 0, 3, 5), Vector2(0, 0), TEXT_STRIDE)
#		offset += TEXT_STRIDE
#	$Label.set('theme_override_fonts/font', font)
#	$LabelShadow.set('theme_override_fonts/font', font)
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_QUAD)
	tw.set_ease(Tween.EASE_OUT)
	tw.set_parallel(true)
	tw.tween_property($LabelShadow, "position", Vector2(0, -3), LIFE)
	tw.tween_property($Label, "position", Vector2(0, -4), LIFE)
	tw.connect('finished', Callable(self, 'finished'))
	
func init(text, position, textcolor, shadowcolor):
	self.scale = Vector2(1, 1)
	self.position = position
	$LabelShadow.text = text
	$LabelShadow.set('theme_override_colors/font_color', shadowcolor)
	$LabelShadow.position = Vector2(0, 1)
	$Label.text = text
	$Label.set('theme_override_colors/font_color', textcolor)
	return self
	
func finished():
	queue_free()

extends Node2D

# TODO: child class (HitLabel, HealLabel, ... that sets standard colors)
# TODO: handle scale (start/end position should also be scaled)
# TODO: position should be center, bottom coord of labelfire
# TODO: kerning info for +/-<number>

const LIFE = 1.0

func _ready():
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_QUAD)
	tw.set_ease(Tween.EASE_OUT)
	tw.tween_property($Label, "position", Vector2(0, -4), LIFE)
	tw.connect('finished', Callable(self, 'finished'))
	
func init(text, position, textcolor, shadowcolor):
	self.position = position
	$Label.text = text
	$Label.set('theme_override_colors/font_color', textcolor)
	$Label.set('theme_override_colors/font_shadow_color', shadowcolor)
	return self
	
func finished():
	queue_free()

extends Node2D

@onready var Event = get_node("/root/Events")

var gametype = 'drink'
var WIDTH : float = 1
var HEIGHT : float = 2

# all objects that can be placed on a horizontal surface - what's right term 
# must implement the width() and height() APIs.  The object placement code picks a 
# Vector2(center, bottom) coordinate which needs to be converted to the Vector2(top, left)
# coordinate

func init(d: Dictionary):
	print("drink %d,%d" % [d['position'].x, d['position'].y])
	position = d['position']
	$Sprite2D.frame = int(randf_range(1, 4))
	
func event(e):
	if e['type'] == Event.BUMP:
		var tw = create_tween()
		tw.set_trans(Tween.TRANS_QUINT)
		tw.set_ease(Tween.EASE_OUT)
		tw.tween_property(self, "position", position + (1* e['dir']), 0.1)
		tw.chain()
		tw.tween_property(self, "position", position, 0.1)

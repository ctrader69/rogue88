extends Node2D

const SPEED = 1

@export var height : int = 5
@export var width : int = 32
@export var percent : int = 0

func _ready():
	$Container.size = Vector2(width, height)
	$Content.size = Vector2(0, 3)
	percent_set(100, true)
	
func percent_set(percent : int, animate : bool):
	self.percent = percent
	var size = Vector2((percent / 100) * (width - 2), 3)
	if animate:
		var tw = create_tween()
		tw.set_trans(Tween.TRANS_QUINT)
		tw.set_ease(Tween.EASE_OUT)
		tw.tween_property($Content, "size", size, SPEED)
	else:
		$Content.size = size

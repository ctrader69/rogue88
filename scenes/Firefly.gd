extends Node2D

func _ready():
	$Sprite2D/AnimationPlayer.play("fly")
	
func fly():
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_QUINT)
	tw.set_ease(Tween.EASE_IN_OUT)
	var dest = Vector2(int(randf_range(0, 7)), int(randf_range(0, 7)))
	print("dest %d,%d" % [dest.x, dest.y])
	var twr = tw.tween_property($Sprite2D, "position", dest, 0.5)
	twr.from_current()

func _on_Timer_timeout():
	print("fly timeout")
	fly()

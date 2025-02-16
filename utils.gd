extends Node

func bump_tween_create(obj, position, dir):
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_QUINT)
	tw.set_ease(Tween.EASE_OUT)
	tw.tween_property(obj, "position", position + Vector2(2 * dir), 0.1)
	tw.chain()
	tw.tween_property(obj, "position", position, 0.1)

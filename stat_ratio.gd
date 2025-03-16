extends Control

const SPEED = 1

@export var numerator = 20
@export var denominator = 20

var display_numerator = 0

func update_label(numerator):
	$Label.text = str(numerator) + "/" + str(denominator)

func update(numerator, denominator):
	self.numerator = numerator
	self.denominator = denominator
	animate()
	
func animate():
	display_numerator = 0
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_QUINT)
	tw.set_ease(Tween.EASE_OUT)
	tw.tween_method(update_label.bind(), 0, numerator, SPEED)
	
func _ready() -> void:
	update(numerator, denominator)
	
func _process(delta: float) -> void:
	pass

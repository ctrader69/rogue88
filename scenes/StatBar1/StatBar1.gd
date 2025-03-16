extends Control

const SPEED = 1

@export var height : int = 8
@export var width : int = 64
@export var percent : int = 0
@export var fill = preload("res://assets/images/scenes/StatBar1/content.png")

@onready var container = $Container
@onready var content = $Content

func _ready():
	container.custom_minimum_size = Vector2(width, height)
	content.texture = fill
	animate()
	
func animate():
	content.size = Vector2(0, height - 2)
	var size = Vector2((percent * width / 100) - 2, height - 2)
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_QUINT)
	tw.set_ease(Tween.EASE_OUT)
	tw.tween_property(content, "size", size, SPEED)

extends Control

const SPEED = 1

@export var height : int = 8
@export var width : int = 64
@export var percent : int = 0
@export var fill = preload("res://assets/images/scenes/StatBar1/content.png")

@onready var container = $MarginContainer/HBoxContainer/MarginContainer/Container
@onready var content = $MarginContainer/HBoxContainer/MarginContainer/MarginContainer/Content

# TODO: this isn't animating anymore, why?

func _ready():
	container.custom_minimum_size = Vector2(width, height)
	content.size = Vector2(0, height - 2)
	percent_set(100, true)
	content.texture = fill
	
func percent_set(percent : int, animate : bool):
	self.percent = percent
	var size = Vector2((percent / 100) * (width - 2), height - 2)
	if animate:
		var tw = create_tween()
		tw.set_trans(Tween.TRANS_QUINT)
		tw.set_ease(Tween.EASE_OUT)
		tw.tween_property(content, "size", size, SPEED)
	else:
		content.size = size

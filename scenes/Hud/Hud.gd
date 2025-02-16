extends Node2D

const HEIGHT = 6
@export var zoom : float = 1
const SPEED = 0.5
const TOP = Vector2(8, 1)
var BOTTOM = Vector2(8, 128 - 1 - (HEIGHT * zoom))

@onready var EventBus = get_node("/root/EventBus")
var location = 'top'

func _ready():
	scale = Vector2(zoom, zoom)
	$Heart/AnimationPlayer.play("idle")
	EventBus.connect('player_turn', Callable(self, 'on_player_turn'))
	position = TOP
	$CoinCount.text = "%d" % 10
	
func on_player_turn():
	var player = get_node("../../Player")
	print("player : %d,%d" % [player.position.x, player.position.y])
	match location:
		'top':
			if player.position.y < 56:
				var tw = create_tween()
				tw.set_trans(Tween.TRANS_QUART)
				tw.set_ease(Tween.EASE_OUT)
				tw.tween_property(self, "position", BOTTOM, SPEED)
				location = 'bottom'
		'bottom':
			if player.position.y > 56:
				var tw = create_tween()
				tw.set_trans(Tween.TRANS_QUART)
				tw.set_ease(Tween.EASE_OUT)
				tw.tween_property(self, "position", TOP, SPEED)
				location = 'top'

extends Node2D

var contents = "poo"

func update():
	if contents == "water":
		$Contents.modulate = Color(0, 0, 1, 0.5)
	elif contents == "pee":
		$Contents.modulate = Color(1, 1, 0, 0.5)
	elif contents == "poo":
		$Contents.modulate = Color(0.35, 0.31, 0.1, 0.78)
		
func _ready():
	update()
	$Contents/AnimationPlayer.play("ebb-flow")

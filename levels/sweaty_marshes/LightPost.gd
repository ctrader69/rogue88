extends Node2D

func _ready():
	$Control/AnimationPlayer.play("sway")
	$Control/Light3D.frame = 1


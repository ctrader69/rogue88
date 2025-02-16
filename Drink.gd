extends Node2D

var gametype = 'drink'

func init(d: Dictionary):
	position = d['position']
	$Sprite2D.frame = randi() % 4

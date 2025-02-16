extends "res://LevelBase.gd"

func _ready():
	mapdata[Vector2i(5, -13)] = {'text' : "To level 2, enter at your own risk!"}
	mapdata[Vector2i(1, 5)] = {
		'items' : [
			['bow-wooden', {}],
			['bow-wooden', {}],
		]
	}

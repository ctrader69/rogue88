extends Node2D

var gametype = 'vase'
var filled = true

func _ready():
	$Sprite2D.frame = 1
	pass
	
func is_solid():
	return true
		
func event(event):
	if event == 'interact':
		if filled:
			$TreasureGrab.play()
			$Sprite2D.frame = 0
			filled = false
		else:
			pass
			

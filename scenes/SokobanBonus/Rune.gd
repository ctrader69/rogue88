extends Node2D

var gametype = 'rune'
var torch = null

func init(d : Dictionary):
	position = d['position']
	
func is_solid():
	return false
	
func covered_set(covered: bool):
	if covered:
		torch.extinguish()
	else:
		torch.lite()

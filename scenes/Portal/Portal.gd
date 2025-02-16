extends Node2D

var gametype = 'portal'
var active = true

func init(d : Dictionary):
	position = d['position']

func is_solid():
	return true
	
func event(e):
	pass

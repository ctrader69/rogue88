extends Node2D

var gametype = 'torch'

var rune = null
var lit = true

func init(d : Dictionary):
	position = d['position']
	lite()
	
func is_solid():
	return false
	
func extinguish():
	$GPUParticles2D.emitting = false
	lit = false

func lite():
	$GPUParticles2D.emitting = true
	lit = true

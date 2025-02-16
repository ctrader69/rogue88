extends Control

@onready var npr = get_child(0)
@onready var img = npr.get_child(0)
@onready var normal = npr.texture
@onready var pressed = preload("res://assets/images/scenes/Container/button-pressed.png")

signal button_pressed

var state = 'idle'
	
func state_change(state):
	if state == 'idle':
		npr.texture = normal
		img.position.y -= 1
	elif state == 'pressed':
		npr.texture = pressed
		img.position.y += 1
	self.state = state
			
func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and state == 'idle':
			state_change('pressed')
		elif not event.pressed and state == 'pressed':
			state_change('idle')
			emit_signal('button_pressed')

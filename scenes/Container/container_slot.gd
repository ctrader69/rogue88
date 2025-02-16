extends Control

@onready var bg = $BackgroundMask

var selected = false

func select():
	selected = true
	bg.material.set_shader_parameter("selected", 1.)
	
func deselect():
	selected = false
	bg.material.set_shader_parameter("selected", 0.)

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if selected:
				deselect()
			else:
				select()

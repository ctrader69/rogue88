extends Node2D
@export var rows : int
@export var columns : int
@export var slot_size : int = 10

@onready var base = $NinePatchRect
@onready var grid = $MarginContainer/MarginContainer/VBoxContainer/GridContainer

func _ready():
	grid.columns = columns
	for row in rows:
		for col in columns:
			var n = preload("res://scenes/Container/container_slot.tscn").instantiate()
			n.set_owner(grid)
			grid.add_child(n)
			
func _process(delta):
	$Cursor.position = get_global_mouse_position()
	pass

func _on_all_button_button_pressed():
	var all = true
	for n in grid.get_children():
		if not n.selected:
			all = false
	
	for n in grid.get_children():
		if all:
			n.deselect()
		else:
			n.select()
		
func _on_check_button_button_pressed():
	queue_free()
		
func add(n):
	pass

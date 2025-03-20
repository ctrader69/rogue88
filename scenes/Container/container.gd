extends Node2D
@export var rows : int
@export var columns : int
@export var slot_size : int = 10

var grid = null
var slots = {}
var contents = {}

func _ready():
	pass
	
func init():
	grid = get_node("./MarginContainer/MarginContainer/VBoxContainer/GridContainer")
	grid.columns = columns
	for row in rows:
		for col in columns:
			var i = Vector2i(row, col)
			var slot = preload("res://scenes/Container/container_slot.tscn").instantiate()
			slots[i] = slot
			contents[i] = null
			slot.set_owner(grid)
			grid.add_child(slot)
			
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
	for row in rows:
		for col in columns:
			var i = Vector2i(row, col)
			if contents[i] == null:
				contents[i] = n
				# TODO: move this to the object itself?
				var inventory_item = preload('res://scenes/InventoryItem.tscn').instantiate()
				var data = Items.ITEMS[n.gametype]
				data['equipped'] = false
				data['count'] = 1
				inventory_item.init(data)
				var slot = slots[i]
				inventory_item.set_owner(slot)
				slot.add(inventory_item)
				return true
	return false

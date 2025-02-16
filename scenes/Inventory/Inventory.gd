#
# Inventory:
#   grid of InventoryItem scenes
#   ItemCard - info card for item
#   --------------------------------
#   items[]:
#     Vector2(0, 0) -> InventoryItem
#                      Item
#     Vector2(1, 0) -> InventoryItem
#                      Item
#     ...
#     Vector2(9, 9) -> InventoryItem
#                      Item
#
#  InventoryItem
#    
#  ItemCard
#    card sprite + item sprite + name + description labels
#    -----------------------------------------------------
#    item - item name
extends Node2D

# TODO: cancel tween (can get out of alignment)

@export var SPEED : float = 0.5
@export var SELECTOR_SPEED : float = 0.2
@export var CARD_SPEED : float = 0.2

const SHOW_COORD = Vector2(2.5, 2.5)
const HIDDEN_COORD = Vector2(2.5, 128)

@onready var Items = get_node("/root/Items")
@onready var SELECTOR_STRIDE = 10 + 1
@onready var COLUMNS = $NinePatchRect/GridContainer.columns
@onready var MAX_INDEX = COLUMNS * COLUMNS

var items = {}
var state = 'deactivated'
var selection = Vector2(0, 0)
@onready var actor = get_node('../..')

func index_to_coord(index : int):
	return Vector2(floor(index % COLUMNS), floor(index / COLUMNS))

func coord_to_index(coord : Vector2):
	return (coord.y * COLUMNS) + coord.x
	
func _ready():
	position = HIDDEN_COORD
	$ItemCard.position = Vector2(128, 5)
	
var card_hidden = true

func card_hide_finished_handler():
	if selection in items and items[selection] and visible:
		card_show()

func card_hide():
	$ItemCard.item_clear()
	card_hidden = true
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_QUINT)
	tw.set_ease(Tween.EASE_OUT)
	var twr = tw.tween_property($ItemCard, "position", Vector2(128, 5), CARD_SPEED)
	twr.connect('finished', Callable(self, 'card_hide_finished_handler'))

func card_show():
	$ItemCard.item_set(items[selection]['Item'].gametype)
	card_hidden = false
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_QUINT)
	tw.set_ease(Tween.EASE_OUT)
	tw.tween_property($ItemCard, "position", Vector2(64, 5), CARD_SPEED)
	
func card_update():
	if not card_hidden:
		card_hide()
	else:
		if selection in items and items[selection]:
			card_show()
			
func _unhandled_input(event):
	if state == 'activated':
		var handled = false
		if event.is_action_pressed('ui_w'):
			if selection.y > 0:
				selection.y -= 1
				tween_selector($Selector.position - Vector2(0, SELECTOR_STRIDE))
				card_update()
			handled = true
		if event.is_action_pressed('ui_s'):
			if selection.y < COLUMNS - 1:
				selection.y += 1
				tween_selector($Selector.position + Vector2(0, SELECTOR_STRIDE))
				card_update()
			handled = true
		if event.is_action_pressed('ui_a'):
			if selection.x > 0:
				selection.x -= 1
				tween_selector($Selector.position - Vector2(SELECTOR_STRIDE, 0))
				card_update()
			handled = true
		if event.is_action_pressed('ui_d'):
			if selection.x < COLUMNS - 1:
				selection.x += 1
				tween_selector($Selector.position + Vector2(SELECTOR_STRIDE,0))
				card_update()
		if event.is_action_pressed('interact'):
			if selection in items:
				var inventory_item = items[selection]['InventoryItem']
				var item = items[selection]['Item']
				if item.equipped:
					if actor.unequip(item):
						item.toggle_equipped()
				else:
					if actor.equip(item):
						item.toggle_equipped()
		if event.is_action_pressed('drop'):
			if selection in items:
				var inventory_item = items[selection]['InventoryItem']
				var item = items[selection]['Item']
				if actor.drop(item):
					items.erase(selection)
					item.queue_free()
		if event.is_action_pressed('inventory'):
			toggle()
		
		get_viewport().set_input_as_handled()
		
func find_free_slot():
	for i in range(0, MAX_INDEX):
		var coord = Vector2(index_to_coord(i))
		if not coord in items:
			return coord
	return null
	
func add(item):
	assert(item.gametype in Items.ITEMS)
	
	# TODO: full handling.
	var coord = find_free_slot()
	
	# TODO: replace these two lines with Container() method.
	var i = coord_to_index(coord)
	var container = $NinePatchRect/GridContainer.get_child(i)
	
	var inventory_item = preload('res://scenes/InventoryItem.tscn').instantiate()
	var data = Items.ITEMS[item.gametype]
	data['equipped'] = false
	data['count'] = 1
	inventory_item.init(data)
	container.add_child(inventory_item)
	inventory_item.set_owner(container)

	items[coord] = {
		'InventoryItem' : inventory_item,
		'Item' : item
	}
	
func remove(gametype):
	for coord in items.keys():
		var item = items[coord]['Item']
		if gametype == item.gametype:
			pass
			#n.remove()
			#if n.count == 0:
				#items.erase(coord)
				#n.queue_free()
	
func has(gametype):
	for coord in items.keys():
		var item = items[coord]['Item']
		if gametype == item.gametype:
			return true
	return false
		
func tween_selector(dst: Vector2):
	$SelectionSfx.play()
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_QUINT)
	tw.set_ease(Tween.EASE_OUT)
	tw.tween_property($Selector, "position", dst, SELECTOR_SPEED)
	
func tween_show_finished_handler():
	card_update()
	
func tween():
	var dst = HIDDEN_COORD if state == 'deactivated' else SHOW_COORD
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_QUINT)
	tw.set_ease(Tween.EASE_OUT)
	var twr = tw.tween_property(self, "position", dst, SPEED)
	if state == 'activated':
		twr.connect('finished', Callable(self, 'tween_show_finished_handler'))
		
func activate():
	state = 'activated'
	$ShowSfx.play()
	tween()
	
func deactivate():
	if not card_hidden:
		card_hide()
	state = 'deactivated'
	tween()
	
func toggle():
	if state == 'deactivated':
		activate()
	else:
		deactivate()
		
#func set_actor(actor: Node):
#	self.actor = actor

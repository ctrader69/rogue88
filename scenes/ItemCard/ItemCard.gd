extends Node2D

@onready var Items = get_node("/root/Items")

var item : String = ''

func _ready():
	pass

func item_set(item):
	self.item = item
	$Name.text = Items.ITEMS[item].name
	$Description.text = Items.ITEMS[item].description
	$Item.texture = Items.ITEMS[item]['inventory-texture']
	
func item_clear():
	item = ''
	$Name.text = ''
	$Description.text = ''
	$Item.texture = null

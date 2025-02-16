extends Node2D

@onready var Items = get_node("/root/Items")

var gametype : String = ''

func _ready():
	pass

# TODO: Fixup my terminology obj/item etc.
#       assume everything can be held, not just 'items'.
#       some objects are Inanimate (eg. charcoal).

func item_set(gametype):
	self.gametype = gametype
	assert(gametype in Items.ITEMS)
	$Name.text = Items.ITEMS[gametype]['name']
	$Description.text = Items.ITEMS[gametype]['description']
	$Item.texture = Items.ITEMS[gametype]['inventory-texture']
	
func item_clear():
	gametype = ''
	$Name.text = ''
	$Description.text = ''
	$Item.texture = null

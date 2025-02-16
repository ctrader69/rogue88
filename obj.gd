extends Node

var DATA = {
	'arrows' : {
		'init'     : {
			'gametype' : 'arrows',
			'texture'  : load('res://scenes/Arrows/arrows.png'),
		},
		'pushable' : false,
		'scene'    : preload("res://scenes/Item/Item.tscn"),
		'solid'    : false,
	},
	'bow-wooden' : {
		'init'     : {},
		'pushable' : false,
		'scene'    : preload("res://scenes/Weapons/Bow/bow.tscn"),
		'solid'    : false,
	},
	'chest' : {
		'init'     : {'dir' : 'down', 'locked' : false},
		'pushable' : false,
		'scene'    : preload("res://Chest.tscn"),
		'solid'    : true,
	},
	'bananas' : {
		'scene'    : preload("res://scenes/Item/Item.tscn"),
		'init'     : {'item' : 'bananas'},
		'solid'    : false,
		'pushable' : false,
	},
	'barrel' : {
		'scene'    :  preload("res://scenes/Barrel/Barrel.tscn"),
		'solid'    : true,
		'pushable' : false,
	},
	'barrel-green' : {
		'scene'    :  preload("res://scenes/Barrel/Barrel.tscn"),
		'solid'    : true,
		'pushable' : false,
	},
	'barrel-red' : {
		'scene'    :  preload("res://scenes/Barrel/Barrel.tscn"),
		'solid'    : true,
		'pushable' : false,
	},
	'barrel-water' : {
		'scene'    :  preload("res://scenes/Barrel/Barrel.tscn"),
		'solid'    : true,
		'pushable' : false,
	},
	'barrel-yellow' : {
		'scene'    : preload("res://scenes/Barrel/Barrel.tscn"),
		'solid'    : true,
		'pushable' : false,
	},
	'bat' : {
		'blood' : 'red',
		'scene' : preload("res://scenes/Bat.tscn"),
		'pushable' : false,
		'solid' : true,
	},
	'bartop-top-left' : {
		'init'     : {'section' : 'top-left'},
		'scene'    : preload("res://scenes/Bartop/Bartop.tscn"),
		'solid'    : false,
		'pushable' : false,
	},
	'bartop-middle-left' : {
		'init'     : {'section' : 'middle-left'},
		'scene'    : preload("res://scenes/Bartop/Bartop.tscn"),
		'solid'    : false,
		'pushable' : false,
	},
	'bartop-bottom-left' : {
		'init'     : {'section' : 'bottom-left'},
		'scene'    : preload("res://scenes/Bartop/Bartop.tscn"),
		'solid'    : false,
		'pushable' : false,
	},
	'bartop-bottom-middle' : {
		'init'     : {'section' : 'bottom-middle'},
		'scene'    : preload("res://scenes/Bartop/Bartop.tscn"),
		'solid'    : false,
		'pushable' : false,
	},
	'bartop-bottom-door' : {
		'init'     : {'section' : 'bottom-door'},
		'scene'    : preload("res://scenes/Bartop/Bartop.tscn"),
		'solid'    : false,
		'pushable' : false,
	},
	'bartop-bottom-right' : {
		'init'     : {'section' : 'bottom-right'},
		'scene'    : preload("res://scenes/Bartop/Bartop.tscn"),
		'solid'    : false,
		'pushable' : false,
	},
	'bartop-middle-right' : {
		'init'     : {'section' : 'middle-right'},
		'scene'    : preload("res://scenes/Bartop/Bartop.tscn"),
		'solid'    : false,
		'pushable' : false,
	},
	'bartop-top-right' : {
		'init'     : {'section' : 'top-right'},
		'scene'    : preload("res://scenes/Bartop/Bartop.tscn"),
		'solid'    : false,
		'pushable' : false,
	},
	'bookshelf-empty' : {
		'init'     : {'full' : false},
		'scene'    : preload("res://scenes/Bookshelf/Bookshelf.tscn"),
		'solid'    : false,
		'pushable' : false,
	},
	'bookshelf-full' : {
		'init'     : {'full' : true},
		'scene'    : preload("res://scenes/Bookshelf/Bookshelf.tscn"),
		'solid'    : false,
		'pushable' : false,
	},
	'blueberry' : {
		'scene'    : preload("res://scenes/Item/Item.tscn"),
		'init'     : {'item' : 'blueberry'},
		'solid'    : false,
		'pushable' : false,
	},
	'coconut' : {
		'scene'    : preload("res://scenes/Item/Item.tscn"),
		'init'     : {'item' : 'coconut'},
		'solid'    : false,
		'pushable' : false,
	},
	'crate' : {
		'scene'    : preload("res://scenes/Crate/Crate.tscn"),
		'solid'    : true,
		'pushable' : true,
	},
	'currant' : {
		'scene'    : preload("res://scenes/Item/Item.tscn"),
		'init'     : {'item' : 'currant'},
		'solid'    : false,
		'pushable' : false,
	},
	'dead-frog' : {
		'scene'    : preload("res://scenes/Item/Item.tscn"),
		'init'     : {'item' : 'dead-frog'},
		'solid'    : false,
		'pushable' : false,
	},
	'dead-hair' : {
		'scene'    : preload("res://scenes/Item/Item.tscn"),
		'init'     : {'item' : 'dead-hair'},
		'solid'    : false,
		'pushable' : false,
	},
	'dead-mouse' : {
		'scene'    : preload("res://scenes/Item/Item.tscn"),
		'init'     : {'item' : 'dead-mouse'},
		'solid'    : false,
		'pushable' : false,
	},
	'delphinium' : {
		'scene'    : preload("res://scenes/Item/Item.tscn"),
		'init'     : {'item' : 'delphinium'},
		'solid'    : false,
		'pushable' : false,
	},
	'donut-lasso' : {
		'scene'    : preload("res://scenes/Item/Item.tscn"),
		'init'     : {'item' : 'donut-lasso'},
		'solid'    : false,
		'pushable' : false,
	},
	'door' : {
		'scene'    : preload("res://scenes/Door.tscn"),
		'init'     : {'dir' : 'down', 'locked' : false},
		'solid'    : true,
		'pushable' : false,
	},
	'door-left' : {
		'scene'    : preload("res://scenes/Door.tscn"),
		'init'     : {'dir' : 'left', 'locked' : false},
		'solid'    : true,
		'pushable' : false,
	} ,
	'door-locked' : {
		'scene'    : preload("res://scenes/Door.tscn"),
		'init'     : {'dir' : 'down', 'locked' : true},
		'solid'    : true,
		'pushable' : false,
	},
	'door-right' : {
		'scene'    : preload("res://scenes/Door.tscn"),
		'init'     : {'dir' : 'right', 'locked' : false},
		'solid'    : true,
		'pushable' : false,
	},
	'fireplace' : {
		'init'     : {'lit' : false},
		'scene'    : preload("res://scenes//Fireplace/Fireplace.tscn"),
		'solid'    : true,
		'pushable' : false,
	},
	'fireplace-lit' : {
		'init'     : {'lit' : true},
		'scene'    : preload("res://scenes//Fireplace/Fireplace.tscn"),
		'solid'    : true,
		'pushable' : false,
	},
	'firewood' : {
		'scene'    : preload("res://scenes/Item/Item.tscn"),
		'init'     : {
			'gametype' : 'firewood',
			'texture'  : preload('res://assets/images/scenes/Firewood/firewood.png'),
		},
		'solid'    : false,
		'pushable' : false,
	},
	# TODO: make this a scene
	'floorspikes' : {
		'solid'    : false,
		'pushable' : false,
	},
	'fly-agaric' : {
		'scene'    : preload("res://scenes/Item/Item.tscn"),
		'init'     : {'item' : 'fly-agaric'},
		'solid'    : false,
		'pushable' : false,
	},
	'persons-hand' : {
		'scene'    : preload("res://scenes/Item/Item.tscn"),
		'init'     : {'item' : 'persons-hand'},
		'solid'    : false,
		'pushable' : false,
	},
	'mint-leaf' : {
		'scene'    : preload("res://scenes/Item/Item.tscn"),
		'init'     : {'item' : 'mint-leaf'},
		'solid'    : false,
		'pushable' : false,
	},
	'poisonous-frog' : {
		'blood' : 'purple',
		'scene' : preload("res://scenes/MOBs/PoisonousFrog/PoisonousFrog.tscn"),
		'solid' : true,
	},
	'portal' : {
		'scene'    : preload("res://scenes/Portal/Portal.tscn"),
		'solid'    : true,
		'pushable' : false,
	},
	'lavender' : {
		'scene'    : preload("res://scenes/Item/Item.tscn"),
		'init'   : {'item' : 'lavender'},
		'solid'    : false,
		'pushable' : false,
	},
	'newt-eye' : {
		'scene'    : preload("res://scenes/Item/Item.tscn"),
		'init'     : {'item' : 'newt-eye'},
		'solid'    : false,
		'pushable' : false,
	},
	'rat' : {
		'blood' : 'purple',
		'scene' : preload("res://scenes/MOBs/Rat/Rat.tscn"),
		'solid' : true,
	},
	'rock-grains' : {
		'scene'    : preload("res://scenes/Item/Item.tscn"),
		'init'     : {'item' : 'rock-grains'},
		'solid'    : false,
		'pushable' : false,
	},
	'romaine' : {
		'scene'    : preload("res://scenes/Item/Item.tscn"),
		'init'     : {'item' : 'romaine'},
		'solid'    : false,
		'pushable' : false,
	},
	'sign' : {
		'scene'    : preload("res://scenes/Sign.tscn"),
		'solid'    : false,
		'pushable' : false,
	},
	# TODO: make this a scene
	'staircase-down' : {
		'solid'    : true,
		'pushable' : false,
	},
	# TODO: make this a scene
	'staircase-up' : {
		'solid'    : true,
		'pushable' : false,
	},
	'table' : {
		'scene'    : preload("res://scenes/Table/Table.tscn"),
		'solid'    : true,
		'pushable' : false,
	},
	'tiger-lily' : {
		'scene'    : preload("res://scenes/Item/Item.tscn"),
		'init'     : {'item' : 'tiger-lily'},
		'solid'    : false,
		'pushable' : false,
	},
	# TODO: make this a scene
	'vase' : {
		'solid'    : true,
		'pushable' : false,
	},
	'vase-filled' : {
		'scene'    : preload("res://Vase.tscn"),
		'solid'    : true,
		'pushable' : false,
	},
	# TODO: make this a scene
	'veg' : {
		'solid'    : false,
		'pushable' : false,
	},
	'wheat' : {
		'scene'    : preload("res://scenes/Item/Item.tscn"),
		'init'     : {'item' : 'wheat'},
		'solid'    : false,
		'pushable' : false,
	},
	'wood-spikes-trap' : {
		'scene'    : preload("res://scenes/WoodSpikesTrap/WoodSpikesTrap.tscn"),
		'solid'    : false,
		'pushable' : false,
	},
	'zombie' : {
		'blood' : 'red',
		'scene' : preload("res://scenes/Zombie/Zombie.tscn"),
		'solid' : true,
	}
}

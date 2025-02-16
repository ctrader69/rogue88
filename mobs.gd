extends Node

# TODO: combine blood/blood-color into one.
# TODO: blood-color should really be blood-hue - The bloodstains currently look too dark.

const MOBS = {
	'bat' : {
		'blood'       : 'red',
		'blood-color' : Color(1.0, 0, 0),
		'scene'       : preload("res://scenes/Bat.tscn"),
		'solid'       : true,
	},
	'zombie' : {
		'blood'       : 'red',
		'blood-color' : Color(1.0, 0, 0),
		'scene'       : preload("res://scenes/Zombie/Zombie.tscn"),
		'solid'       : true,
	},
	'poisonous-frog' : {
		'blood'       : 'purple',
		'blood-color' : Color(1.0, 0.0, 1.0),
		'scene'	      : preload("res://scenes/MOBs/PoisonousFrog/PoisonousFrog.tscn"),
		'solid'       : true,
	},
	'rat' : {
		'blood' 	  : 'red',
		'blood-color' : Color(1.0, 0, 0),
		'scene'       : preload("res://scenes/MOBs/Rat/Rat.tscn"),
		'solid'       : true,
	},
	'barkeep' : {
		'blood'       : 'red',
		'blood-color' : Color(1.0, 0, 0),
		'scene'       : preload("res://scenes/MOBs/Barkeep/Barkeep.tscn"),
		'solid'       : true,
	}
}

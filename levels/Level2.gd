extends "res://LevelBase.gd"

func init(description):
	mapdata = {
		Vector2i(4, 5) : {
			'contents' : [
				{
					'gametype' : 'potion',
					'initdata' : {}
				},
			]
		}
	}
	super.init(description)

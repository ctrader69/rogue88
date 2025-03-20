extends "res://LevelBase.gd"

func init(description):
	mapdata = {
		Vector2i(4, 5) : {
			'contents' : [
				{
					'gametype' : 'bow',
					'initdata' : {}
				},
			]
		}
	}
	super.init(description)

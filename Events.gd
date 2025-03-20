extends Node

enum {
	ATTACK,
	BUMP,
	CLOSE,
	DROPPED,
	EQUIPPED,
	IGNITE,
	INTERACT,
	GET,
	LOAD,
	OPEN,
	TAKEN,
	UNEQUIPPED,
}

func make(type, src):
	return {
		'type' : type,
		'src' : src,
	}

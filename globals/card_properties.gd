extends Resource
class_name CardProperties

enum Class {ATTRIBUTE, FORCE, BUFF, WASTE}
enum Type {COAX, SPECULATE, EXCITE}

export var card_cost := 1
export (float) var effect_aggressive = 0.0
export (float) var effect_nervous = 0.0
export (float) var effect_fatigue = 1.0


#{
#	"name": "",
#	"cost": 1,
#	"effect_aggressive": 0.0,
#	"effect_nervous": 0.0,
#	"effect_fatigue": 0.0,
#	"tooltip": "",
#	"icon": preload(""),
#	"base_color": Color()
#},


var card_database = {
	Type.COAX: {
		"name": "Coax",
		"cost": 1,
		"effect_aggressive": 5.0,
		"effect_nervous": 0.0,
		"effect_fatigue": 5.0,
		"tooltip": "Go on... you don't want to look poor, do you?"
#		"icon": preload(""),
#		"base_color": Color()
	},
	Type.SPECULATE: {
		"name": "Speculate",
		"cost": 1,
		"effect_aggressive": 0.0,
		"effect_nervous": 0.0,
		"effect_fatigue": 0.0,
		"tooltip": "Real Magazine said this place can't lose money!"
#		"icon": preload(""),
#		"base_color": Color()
	},
}


var card_effects = {
	
}

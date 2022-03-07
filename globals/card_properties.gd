extends Resource
class_name CardProperties

enum Class {ATTRIBUTE, FORCE, BUFF, WASTE}
enum Type {
	COAX, 
	SPECULATE, 
	EXCITE, 
	FORCE,
	SKIP
	}

export var card_cost := 1
export (float) var effect_aggressive = 0.0
export (float) var effect_nervous = 0.0
export (float) var effect_fatigue = 1.0


const card_database = {
	Type.COAX: {
		"name": "COAX",
		"class": Class.ATTRIBUTE,
		"level": 1,
		"flavourtext": '"Go on... you don`t want to look poor, do you?"',
		"effect_1_method": ["change_attribute", [EnemyProperties.Attribute.AGGRO, 5.0]],
		"effect_1_icon": preload("res://assets/ui/icon_aggro.png"),
		"effect_1_text": "+5",
		"effect_2_method": ["change_attribute", [EnemyProperties.Attribute.FATIGUE, 5.0]],
		"effect_2_icon": preload("res://assets/ui/icon_fatigue.png"),
		"effect_2_text": "+5"
	},
	Type.SPECULATE: {
		"name": "SPECULATE",
		"class": Class.ATTRIBUTE,
		"level": 1,
		"flavourtext": '"Real Magazine said this place can`t lose money!"',
		"effect_1_method": ["change_attribute", [EnemyProperties.Attribute.NERVE, -5.0]],
		"effect_1_icon": preload("res://assets/ui/icon_nerve.png"),
		"effect_1_text": "-5",
		"effect_2_method": ["change_attribute", [EnemyProperties.Attribute.FATIGUE, 5.0]],
		"effect_2_icon": preload("res://assets/ui/icon_fatigue.png"),
		"effect_2_text": "+5"
	},
	Type.EXCITE: {
		"name": "EXCITE",
		"class": Class.ATTRIBUTE,
		"level": 1,
		"flavourtext": '"In all my years I haven`t found a better house!"',
		"effect_1_method": ["change_attribute", [EnemyProperties.Attribute.NERVE, -5.0]],
		"effect_1_icon": preload("res://assets/ui/icon_nerve.png"),
		"effect_1_text": "-5",
		"effect_2_method": ["change_attribute", [EnemyProperties.Attribute.FATIGUE, 5.0]],
		"effect_2_icon": preload("res://assets/ui/icon_fatigue.png"),
		"effect_2_text": "+5"
	},
	Type.FORCE: {
		"name": "FORCE",
		"class": Class.FORCE,
		"level": 2,
		"flavourtext": '"You HAVE to put money down here!"',
		"effect_1_method": ["force_bid", []],
		"effect_1_icon": preload("res://assets/ui/icon_force.png"),
		"effect_1_text": "Bid",
		"effect_2_method": null,
		"effect_2_icon": null,
		"effect_2_text": null
	},
	Type.SKIP: {
		"name": "SKIP",
		"class": Class.FORCE,
		"level": 2,
		"flavourtext": '"Just let the others fight it out this time."',
		"effect_1_method": ["force_bid", []],
		"effect_1_icon": preload("res://assets/ui/icon_nerve.png"),
		"effect_1_text": "Skip",
		"effect_2_method": ["change_attribute", [EnemyProperties.Attribute.FATIGUE, -10.0]],
		"effect_2_icon": preload("res://assets/ui/icon_fatigue.png"),
		"effect_2_text": "-10"
	},
}


const class_icons = {
	Class.ATTRIBUTE: preload("res://assets/card/card_icon_attribute.png"),
	Class.FORCE: preload("res://assets/card/card_icon_force.png"),
#	Class.BUFF: preload("res://assets/card/card_icon_buff.png"),
	Class.BUFF: preload("res://assets/card/card_icon_placeholder.png"),
#	Class.WASTE: preload("res://assets/card/card_icon_waste.png"),
	Class.WASTE: preload("res://assets/card/card_icon_placeholder.png"),
}


const level_colours = {
	1: Color("7a4725"),  # Bronze?
	2: Color("a9a48d"),  # Silver
	3: Color("fcc539"),  # Gold
}

const class_colours = {
	Class.ATTRIBUTE: Color("3c62bc"),  # Blue
	Class.FORCE: Color("51bc3c"),  # Green
	Class.BUFF: Color("d8cf0c"),  # Yellow
	Class.WASTE: Color("676767")  # Grey
}


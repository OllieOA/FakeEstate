extends Resource
class_name EnemyProperties

enum Attribute {NERVE, AGGRO, FATIGUE}

enum Type {
	TIMEBOMB,
	FIRST_TIMERS,
	CUCUMBER,
	FALSE_CONFIDENCE,
	TRUST_FUND,
	BULL,
	MILLENIAL,
	CAFFEINATED,
	SAVVY_SHOPPER,
	HAPPY_TO_BE_HERE
}

var possible_first_names = [
	"Cristian",
	"Alexis",
	"Mya",
	"Rylee",
	"Michelle",
	"Jasmin",
	"Katelyn",
	"Jacob",
	"Jack",
	"Matthew",
	"Ariana",
	"Brittany",
	"Marissa",
	"Amelia",
	"Summer",
	"Dalton",
	"Kennedy",
	"Shane",
	"Molly",
	"Mason",
	"Benjamin",
	"Bianca",
	"Alyssa",
	"Addison",
	"Jocelyn",
	"Breanna",
	"Sabrina",
	"Karen",
	"Lucas",
	"Cassidy",
	"Autumn",
	"Sergio",
	"Lauren",
	"Angelica",
	"Julian",
	"Madeline",
	"Colin",
	"Wyatt",
	"Rachel",
	"Kiara"
]

var possible_last_names = [
	"Shaw",
	"Tran",
	"Wright",
	"Gonzalez",
	"Robertson",
	"Spencer",
	"Foster",
	"Wilson",
	"Mcdonald",
	"Cooper",
	"Myers",
	"Thomas",
	"Cunningham",
	"Jimenez",
	"Bradley",
	"Patterson",
	"Stone",
	"Crawford",
	"Garcia",
	"Hughes",
	"Richardson",
	"Knight",
	"Gordon",
	"Castillo",
	"Fisher",
	"Turner",
	"Rivera",
	"Dixon",
	"Boyd",
	"Lee",
	"Nguyen",
	"Bennett",
	"Ramirez",
	"Collins",
	"Torres",
	"Flores",
	"Hamilton",
	"Holmes",
	"Marshall",
	"Mills"
]

# Values are in [aggro, nerves, fatigue]

const enemy_database = {
	Type.TIMEBOMB: {
		"difficulty": 2,
		"class": "TIMEBOMB",
		"flavourtext": "High nerves and high aggression. Here for a quick auction.",
		"starting_values": [20, 20, 0],
		"increase_rates": [12, 12, 8],
		"colour": Color("f78312")
	},
	Type.FIRST_TIMERS: {
		"difficulty": 3,
		"class": "FIRST TIMERS",
		"flavourtext": "High nerves and low aggression. Likely to get scared and fold early.",
		"starting_values": [5, 20, 0],
		"increase_rates": [5, 12, 8],
		"colour": Color("08b7bb")
	},
	Type.CUCUMBER: {
		"difficulty": 1,
		"class": "CUCUMBER",
		"flavourtext": "Low nerves and low aggression. Bidding small but consistently.",
		"starting_values": [5, 5, 0],
		"increase_rates": [5, 5, 8],
		"colour": Color("09700d")
	},
	Type.FALSE_CONFIDENCE: {
		
	},
	Type.TRUST_FUND: {
		
	},
	Type.BULL: {
		
	},
	Type.MILLENIAL: {
		
	},
	Type.CAFFEINATED: {
		
	},
	Type.SAVVY_SHOPPER: {
		
	},
	Type.HAPPY_TO_BE_HERE: {
		
	}
}

# Methods that cards can call

const method_text_lookup = {
	"change_attribute": "Changing %s by %s",
	"skip_bid": "Skipping bid",
	"force_bid": "Forcing a bid"
}


func change_attribute(attribute: int, amount: float) -> void:
	pass


func skip_bid() -> void:
	pass
	
	
func force_bid() -> void:
	pass

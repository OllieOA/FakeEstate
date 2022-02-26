extends Resource
class_name EnemyProperties

enum Attribute {NERVE, AGGRO, FATIGUE}
enum State {BIDDING, BID, BUST, WAITING}  # MOVE THIS TO BASE ENEMY
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

#var type_data = {
#	TIMEBOMB: {
#
#	}
#	FIRST_TIMERS: {
#
#	}
#	CUCUMBER: {
#
#	}
#	FALSE_CONFIDENCE: {
#
#	}
#	TRUST_FUND: {
#
#	}
#	BULL: {
#
#	}
#	MILLENIAL: {
#
#	}
#	CAFFEINATED: {
#
#	}
#	SAVVY_SHOPPER: {
#
#	}
#	HAPPY_TO_BE_HERE: {
#
#	}
#}

# Methods that cards can call

func change_attribute(attribute: int, amount: float) -> void:
	pass


func skip_bid() -> void:
	pass
	
	
func force_bid() -> void:
	pass

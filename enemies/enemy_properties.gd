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


# Methods that cards can call

func change_attribute(attribute: int, amount: float) -> void:
	pass


func skip_bid() -> void:
	pass
	
	
func force_bid() -> void:
	pass

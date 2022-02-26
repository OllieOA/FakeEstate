extends Resource
class_name PlayerDeck

const base_card = preload("res://cards/base_card.tscn")


# These are DATA OBJECTS ONLY, all actual card instance drawing is handled
# in the bidding scene. Methods in this resource only move around the data
var current_deck := []  # Arrays of type enums
var current_discard := []
var current_hand := []
var current_play := []
var current_trash := []
var current_hand_max_size := 5

var rng = RandomNumberGenerator.new()


func initialize() -> void:
	rng.randomize()
	current_deck = PlayerProgress.deck
	draw_up_to(current_hand_max_size)


func draw_up_to(num_cards: int) -> void:
	for _i in range(num_cards):
		print("DRAWING ", _i)
		var new_card = draw()
		if new_card != null: 
			current_hand.append(new_card)
			yield(SignalBus, "hand_repositioned")


func draw():
	if len(current_hand) >= current_hand_max_size:
		return null
	var base_card_instance = base_card.instance()
	var index_choice = rng.randi() % current_deck.size()
	var card_choice = current_deck.pop_at(index_choice)
	base_card_instance.card_type = card_choice
	
	print("DEBUG: EMITTING CARD DRAWN")
	SignalBus.emit_signal("card_drawn", base_card_instance)
	
	# Check if deck exhaused
	if len(current_deck) == 0:
		_return_discard_pile()
	
	return base_card_instance


func discard(card_type: int, index=-1) -> void:
	if index == -1:
		# Find card manually
		index = current_hand.find(card_type)
	
	current_hand.pop_at(index)
	current_discard.append(card_type)


func play(card_type: int, index=-1) -> void:
	if index == -1:
		# Find card manually
		index = current_hand.find(card_type)
	
	current_hand.pop_at(index)
	current_play.append(card_type)


func _return_discard_pile():
	current_deck = current_discard
	current_discard = []
	SignalBus.emit_signal("deck_returned")
	

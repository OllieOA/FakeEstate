extends Node2D


export (Resource) onready var player_deck = player_deck as PlayerDeck

export (NodePath) onready var cards_layer = get_node(cards_layer) as YSort
export (NodePath) onready var deck_button = get_node(deck_button) as TextureButton
export (NodePath) onready var discard_button = get_node(discard_button) as TextureButton
export (PackedScene) var base_card_scene

export (NodePath) onready var bidding_panel = get_node(bidding_panel) as BiddingPanel

# Play area
onready var card_oval_centre = get_viewport().size * Vector2(0.5, 1.3)
onready var card_oval_h_radius = get_viewport().size.x * 0.45
onready var card_oval_v_radius = get_viewport().size.y * 0.4
var max_angle = 135
var min_angle = 45
var player_hand_instances = []
var is_card_selected := false
var card_selected

# Functional
export (NodePath) onready var start_button = get_node(start_button)
var rng = RandomNumberGenerator.new()


func _ready() -> void:
	bidding_panel.visible = false
	rng.randomize()
	
	# Connect signals
	SignalBus.connect("card_drawn", self, "_handle_drawn_card")
	SignalBus.connect("level_dialogue_complete", self, "_show_start")
	SignalBus.connect("card_focusing", self, "_raise_focused_card")
	SignalBus.connect("card_returned", self, "_handle_returned_card")
	SignalBus.connect("card_selected_for_play", self, "_handle_card_selected_for_play")
	SignalBus.connect("card_unselected_for_play", self, "_handle_card_unselected_for_play")
	
	_show_start()
	
	
func _show_start() -> void:
	start_button.visible = true


func _start_game() -> void:
	_create_deck()
	bidding_panel.show_auction_panel()
	yield(get_tree().create_timer(2.0), "timeout")
	bidding_panel.set_bid(100000)
	
	yield(get_tree().create_timer(2.0), "timeout")
	bidding_panel.increase_bid(50000)
	
	yield(get_tree().create_timer(2.0), "timeout")
	bidding_panel.increase_commission_percentage(0.2)


# ------------
# Card methods
# ------------

func _create_deck() -> void:
	# First, generate a deck
	player_deck.initialize()


func _handle_drawn_card(card: BaseCard) -> void:
	player_hand_instances.append(card)
	cards_layer.add_child(card)
	card.rect_position = deck_button.get_global_rect().position - card.rect_pivot_offset
	_reposition_deck()


func _reposition_deck() -> void:
	var new_positions_and_rotations = _calculate_new_positions()
	for i in range(len(player_hand_instances)):
		var curr_card = player_hand_instances[i]
		var curr_card_position = new_positions_and_rotations[i][0] - curr_card.rect_pivot_offset
		var curr_card_rotation = (rad2deg(new_positions_and_rotations[i][1]) * -1)
		var curr_card_scale = Vector2(1.0, 1.0)
		
		curr_card.target_position = curr_card_position
		curr_card.target_rotation = curr_card_rotation
		curr_card.target_scale = curr_card_scale
		
		# Also set this as hand position
		curr_card.hand_position = curr_card_position
		curr_card.hand_rotation = curr_card_rotation
		curr_card.hand_scale = curr_card_scale
		
		yield(get_tree().create_timer(0.01), "timeout")
		
	_update_viewing_order()
	SignalBus.emit_signal("hand_repositioned")


func _calculate_new_positions() -> Array:
	# Returns new positions, rotations, and Z layer
	var positions_and_rotations = []
	var curr_angle = PI/(2*180)  # 90 degree
	var card_angle_gap = deg2rad(15)
	if len(player_hand_instances) % 2 == 0:  # Is even
		curr_angle += card_angle_gap / 2  # Offset to handle even cards
	
	var flipper = 1
	for i in range(len(player_hand_instances)):
		if i % 2 == 0: 
			flipper = 1
		else:
			flipper = -1
			
		curr_angle += card_angle_gap * flipper * i
		
		var x_pos = card_oval_h_radius * sin(curr_angle)
		var y_pos = card_oval_v_radius * cos(curr_angle)
		var next_pos = card_oval_centre - Vector2(x_pos, y_pos)
		positions_and_rotations.append([next_pos, curr_angle, flipper*i])
			
	return positions_and_rotations


func _update_viewing_order():
	var cards = cards_layer.get_children()
	cards.sort_custom(self, "_sort_cards")
	for card in cards:
		card.raise()


static func _sort_cards(a: BaseCard, b: BaseCard) -> bool:
	return a.hand_position.x > b.hand_position.x


func _raise_focused_card(card):
	cards_layer.move_child(card, cards_layer.get_child_count())


func _handle_returned_card(card):
	_update_viewing_order()


func _handle_card_selected_for_play(selected_card):
	for card in cards_layer.get_children():
		if card != selected_card:
			card.mouseover_enabled = false
	is_card_selected = true
	card_selected = selected_card
	

func _handle_card_unselected_for_play(unselected_card):
	for card in cards_layer.get_children():
		if card != unselected_card:
			card.mouseover_enabled = true
	is_card_selected = false
	card_selected = null


# =------------=
# Button methods
# =------------=

func _on_Deck_pressed() -> void:
	# Show player a deck tooltip
	pass # Replace with function body.


func _on_Discard_pressed() -> void:
	# Show player a discard tooltip
	pass # Replace with function body.


func _on_StartGame_pressed() -> void:
	start_button.visible = false
	_start_game()




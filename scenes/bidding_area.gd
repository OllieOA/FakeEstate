extends MarginContainer
class_name BiddingPanel

# Game Win Information

export (NodePath) onready var goals_title = get_node(goals_title) as Label
export (NodePath) onready var bidding_amount = get_node(bidding_amount) as Label
export (NodePath) onready var commission_percentage = get_node(commission_percentage) as Label
export (NodePath) onready var commission_amount = get_node(commission_amount) as Label
export (NodePath) onready var commission_goal = get_node(commission_goal) as Label

export var initial_amount := 100.0
var goal_commission_amount := 4000
var current_bid := 0.0
var target_bid := 0.0
var current_commission_percentage := 0.0
var target_commission_percentage := 1
var current_commission := 0.0
var target_commission := 0.0

var commission_goal_met := false
var panel_update_rate = 0.2


func _ready() -> void:
	_construct_panel()


func _construct_panel() -> void:
	# Update title size
	var font_data = DynamicFont.new()
	font_data.font_data = load("res://fonts/dogicapixel.ttf")
	font_data.size = 20
	goals_title.add_font_override("font", font_data)
	
	commission_goal.set_text("Goal Commission: " + _convert_currency(goal_commission_amount))
	commission_amount.add_color_override("font_color", Color("e01212"))


func _process(delta: float) -> void:
	_update_bid_text()
	_update_commission_text()
	if current_commission > goal_commission_amount and not commission_goal_met:
		commission_goal_met = true


# =--------------=
# Game Win Methods
# =--------------=

func show_auction_panel():
	visible = true


# =--------------------=
# Text Rendering Methods
# =--------------------=

func _convert_currency(amount: float) -> String:
	var currency_string = "%.2f" % amount
	
	for idx in range(currency_string.find(".") - 3, 0, -3):
		currency_string = currency_string.insert(idx, ",")
	currency_string = "$" + currency_string
	return currency_string


func set_bid(amount):
	target_bid = amount


func increase_bid(amount):
	target_bid += amount


func _update_bid_text():
	current_bid = lerp(current_bid, target_bid, panel_update_rate)
	bidding_amount.set_text("Current Bid: " + _convert_currency(current_bid))
	
	
func set_commission_percentage(amount):
	target_commission_percentage = amount
	
	
func increase_commission_percentage(amount):
	target_commission_percentage += amount
	

func decrease_commission_percentage(amount):
	target_commission_percentage -= amount
	
	
func _update_commission_text():
	target_commission = target_bid * target_commission_percentage / 100
	current_commission = lerp(current_commission, target_commission, panel_update_rate)
	current_commission_percentage = lerp(current_commission_percentage, target_commission_percentage, panel_update_rate)
	
	commission_percentage.set_text("Current Commission: " + "%.1f" % current_commission_percentage + "%")
	commission_amount.set_text(_convert_currency(current_commission))
	
	if commission_goal_met:
		commission_amount.add_color_override("font_color", Color("2aaa1e"))
		
		

		
	
	

	

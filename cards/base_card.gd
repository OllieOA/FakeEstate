extends MarginContainer
class_name BaseCard

enum State {
	SENDING_TO_HAND, 
	HAND, 
	PLAYING,
	PLAYED,
	DISCARDING,
	SELECTING,
	DIRECTING, 
	FOCUSING,
	FOCUSED,
	DISABLED,
	}
	

export (Resource) onready var card_properties = card_properties as CardProperties
export (CardProperties.Type) var card_type

onready var card_attributes = card_properties.card_database[card_type]

# Get card nodes
export (NodePath) onready var card_border = get_node(card_border) as NinePatchRect 
export (NodePath) onready var card_title = get_node(card_title) as Label
export (NodePath) onready var level_text = get_node(level_text) as Label
export (NodePath) onready var level_border = get_node(level_border) as NinePatchRect
export (NodePath) onready var class_border = get_node(class_border) as NinePatchRect
export (NodePath) onready var class_icon = get_node(class_icon) as TextureRect
export (NodePath) onready var card_text = get_node(card_text) as Label
export (NodePath) onready var effect_1_icon = get_node(effect_1_icon) as TextureRect
export (NodePath) onready var effect_1_text = get_node(effect_1_text) as Label
export (NodePath) onready var effect_2_icon = get_node(effect_2_icon) as TextureRect
export (NodePath) onready var effect_2_text = get_node(effect_2_text) as Label

export (NodePath) onready var focus_button = get_node(focus_button) as TextureButton


# Get other card things
var base_font_size = 20
var min_card_height = 252
var state = State.SENDING_TO_HAND

# Card positioning
var FOCUS_POSITION = Vector2(0.5, 0.5)  # Relative to viewport

var target_position = Vector2.ZERO
var target_rotation = 90
var target_scale = Vector2(1.0, 1.0)

var position_diff_x := 1.0
var position_diff_y := 1.0

var scale_diff_x := 1.0
var scale_diff_y := 1.0

var position_close_enough := false
var rotation_close_enough := false
var scale_close_enough := false

var hand_position := Vector2.ZERO
var hand_rotation := 0
var hand_scale := Vector2(1.0, 1.0)

var mouseover_enabled := true

# Card control
var drawn := false


func _ready() -> void:
	# Initialise card information
	_construct_card()
	SignalBus.connect("card_focusing", self, "_check_focus")

# Construction and Rendering

func _construct_card() -> void:
	# Move down the card and create each chunk
	
	# Set colours
	card_border.self_modulate = card_properties.class_colours[card_attributes["class"]]
	class_border.self_modulate = card_properties.class_colours[card_attributes["class"]]
	level_border.self_modulate = card_properties.level_colours[card_attributes["level"]]
	
	# Set text
	card_title.set_text(card_attributes["name"])
	card_text.set_text(card_attributes["flavourtext"])
	level_text.set_text(str(card_attributes["level"]))
	effect_1_text.set_text(card_attributes["effect_1_text"])
	
	var title_font_size = _resize_label(card_title)
	var text_font_size = _resize_label(card_text)
	var effect_1_font_size = _resize_label(effect_1_text)
	
	if card_attributes["effect_2_text"] != null:
		effect_2_text.set_text(card_attributes["effect_2_text"])
		var effect_2_font_size = _resize_label(effect_2_text)
	
	# Set icons
	class_icon.texture = card_properties.class_icons[card_type]
	effect_1_icon.texture = card_attributes["effect_1_icon"]
	
	if card_attributes["effect_2_icon"] != null:
		effect_2_icon.texture = card_attributes["effect_2_icon"]
		
	focus_button.disabled = true  # Prevent gold bordering


func _resize_label(label: Label, min_size=8) -> int:
	var pass_label = _check_text_violations(label)
	
	label.visible = false
	var font_data = DynamicFont.new()
	font_data.font_data = load("res://fonts/dogicapixel.ttf")
	
	while not pass_label:
		base_font_size -= 1
		font_data.size = base_font_size
		label.add_font_override("font", font_data)
		
		if base_font_size < min_size:
			break
		
		# Set up check here for any violations
		pass_label = _check_text_violations(label)
	label.visible = true
	return base_font_size


func _check_text_violations(label: Label) -> bool:
	var passed = false
	passed = passed or label.get_line_count() >= label.get_visible_line_count()
	passed = passed or rect_size.x > rect_min_size.x
	return passed

# =-----------=
# State machine
# =-----------=

func _process(delta: float) -> void:
	# Figure out positioning
	rect_position = lerp(rect_position, target_position, 0.2)
	rect_rotation = rad2deg(lerp_angle(deg2rad(rect_rotation), deg2rad(target_rotation), 0.2))
	rect_scale = lerp(rect_scale, target_scale, 0.2)
	
	position_diff_x = abs(rect_position.x - target_position.x)
	position_diff_y = abs(rect_position.y - target_position.y)
	
	scale_diff_x = abs(rect_scale.x - target_scale.x)
	scale_diff_y = abs(rect_scale.y - target_scale.y)
	
	position_close_enough = position_diff_x < 5 and position_diff_y < 5
	rotation_close_enough = abs(rect_rotation - target_rotation) < 5
	scale_close_enough = scale_diff_x < 0.1 and scale_diff_y < 0.1
	
	match state:
		State.HAND:
			pass
		State.PLAYED: 
			pass
		State.SENDING_TO_HAND: # Animate from deck location
			if position_close_enough and rotation_close_enough and scale_close_enough:
				focus_button.disabled = true
				SignalBus.emit_signal("card_returned", self)
				state = State.HAND
		State.DISCARDING:
			pass
		State.SELECTING:
			SignalBus.emit_signal("card_selected_for_play", self)
			state = State.DIRECTING
		State.DIRECTING:  # Selected for play
			if Input.is_action_pressed(GameControl.secondary_action):
				focus_button.pressed = false
				_unfocus()
				SignalBus.emit_signal("card_unselected_for_play", self)
		State.FOCUSING:
			if Input.is_action_pressed(GameControl.secondary_action):
				_unfocus()
			if position_close_enough and rotation_close_enough and scale_close_enough:
				state = State.FOCUSED
				SignalBus.emit_signal("card_focused", self)
		State.FOCUSED:
			if Input.is_action_pressed(GameControl.secondary_action):
				_unfocus()
			if focus_button.disabled:
				focus_button.disabled = false
		State.DISABLED:
			pass

# =---------=
# FOCUS Stuff
# =---------=

func _on_Focus_pressed() -> void:
	match state:
		State.FOCUSED, State.FOCUSING:
			state = State.SELECTING


func _on_Focus_mouse_entered() -> void:
	match state:
		State.HAND:
			if mouseover_enabled:
				_focus()


func _on_Focus_mouse_exited() -> void:
	match state:
		State.FOCUSED:
			_unfocus()


func _check_focus(card):
	if card != self and (state == State.FOCUSED or state == State.FOCUSING):
		_unfocus()


func _focus():
	target_position = get_viewport_rect().size * FOCUS_POSITION - rect_pivot_offset
	target_rotation = 0
	target_scale = Vector2(1.5, 1.5)
	state = State.FOCUSING
	SignalBus.emit_signal("card_focusing", self)


func _unfocus():
	target_position = hand_position
	target_rotation = hand_rotation
	target_scale = hand_scale
	focus_button.disabled = true
	state = State.SENDING_TO_HAND


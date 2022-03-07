extends MarginContainer
class_name BaseEnemy

enum State {
	INACTIVE,
	ACTIVATING,
	ACTIVATED,
	DEACTIVATING,
	FOCUSING,
	FOCUSED,
	SENDING_TO_ROW, # Returning to ACTIVE (INACTIVE?)
	FOLDING,
	FOLDED
}
var state = State.SENDING_TO_ROW

export (NodePath) onready var enemy_border = get_node(enemy_border) as NinePatchRect

export (NodePath) onready var enemy_name = get_node(enemy_name) as Label
export (NodePath) onready var enemy_class = get_node(enemy_class) as Label

export (NodePath) onready var aggro_number = get_node(aggro_number) as Label
export (NodePath) onready var nerve_number = get_node(nerve_number) as Label
export (NodePath) onready var fatigue_number = get_node(fatigue_number) as Label
export (NodePath) onready var fold_number = get_node(fold_number) as Label

export (NodePath) onready var next_turn_effect_list = get_node(next_turn_effect_list) as VBoxContainer

export (NodePath) onready var focus_button = get_node(focus_button) as TextureButton

export (Resource) onready var enemy_properties = enemy_properties as EnemyProperties
export (EnemyProperties.Type) onready var enemy_type

onready var enemy_attributes = enemy_properties.enemy_database[enemy_type]
var rng := RandomNumberGenerator.new()

# Enemy attributes
var current_aggro := 0.0
onready var target_aggro: float = enemy_attributes["starting_values"][0]
onready var aggro_increase_rate: float = enemy_attributes["increase_rates"][0]

var current_nerve := 0.0
onready var target_nerve: float = enemy_attributes["starting_values"][1]
onready var nerve_increase_rate: float = enemy_attributes["increase_rates"][1]

var current_fatigue := 0.0
onready var target_fatigue: float = enemy_attributes["starting_values"][2]
onready var fatigue_increase_rate: float = enemy_attributes["increase_rates"][2]

var current_fold := 0.0
var target_fold := 0.0

var panel_update_rate = 0.2

var mouseover_enabled := true

# Card positioning
var FOCUS_POSITION = Vector2(0.6, 0.5)

var target_position = Vector2.ZERO
var target_rotation = 0
var target_scale = Vector2(0.8, 0.8)

var position_diff_x := 1.0
var position_diff_y := 1.0

var scale_diff_x := 1.0
var scale_diff_y := 1.0

var position_close_enough := false
var rotation_close_enough := false
var scale_close_enough := false
var close_enough := false

var lerp_factor := 0.2

var row_position := Vector2.ZERO
var row_rotation := 0
var row_scale := Vector2(1.0, 1.0)

# Game control
var selectable := false


func _ready() -> void:
	rng.randomize()
	_construct_card()
	SignalBus.connect("enemy_focusing", self, "_check_focus")
	
#	# TESTING
#	print("DEBUG: AGGRO: ", target_aggro, " | ", current_aggro)
#
#	yield(get_tree().create_timer(2.0), "timeout")
#	target_aggro = 40
#	print("DEBUG: AGGRO: ", target_aggro, " | ", current_aggro)
#
#	yield(get_tree().create_timer(2.0), "timeout")
#	_add_next_turn_line("Increasing aggro by 5")
	


func _process(_delta: float) -> void:
	# Update text
	current_aggro = _update_attribute_text(current_aggro, target_aggro, aggro_number)
	current_nerve = _update_attribute_text(current_nerve, target_nerve, nerve_number)
	current_fatigue = _update_attribute_text(current_fatigue, target_fatigue, fatigue_number)
	current_fold = _update_attribute_text(current_fold, target_fold, fold_number)

	# Figure out positioning
	rect_position = lerp(rect_position, target_position, lerp_factor)
	rect_rotation = rad2deg(lerp_angle(deg2rad(rect_rotation), deg2rad(target_rotation), lerp_factor))
	rect_scale = lerp(rect_scale, target_scale, lerp_factor)
	
	position_diff_x = abs(rect_position.x - target_position.x)
	position_diff_y = abs(rect_position.y - target_position.y)
	
	scale_diff_x = abs(rect_scale.x - target_scale.x)
	scale_diff_y = abs(rect_scale.y - target_scale.y)
	
	position_close_enough = position_diff_x < 1 and position_diff_y < 1
	rotation_close_enough = abs(rect_rotation - target_rotation) < 1
	scale_close_enough = scale_diff_x < 0.1 and scale_diff_y < 0.1
	
	close_enough = position_close_enough and rotation_close_enough and scale_close_enough
	
	# State machine
	match state:
		State.SENDING_TO_ROW:  # Initial state
			if close_enough:
				state = State.INACTIVE
				focus_button.disabled = true
		State.INACTIVE:
			pass
		State.FOCUSING:
			if Input.is_action_pressed(GameControl.secondary_action):
				_unfocus()
			if close_enough:
				SignalBus.emit_signal("enemy_focused", self)
				state = State.FOCUSED
		State.FOCUSED:
			if Input.is_action_pressed(GameControl.secondary_action):
				_unfocus()
			if focus_button.disabled and selectable:
				focus_button.disabled = false
		State.ACTIVATING:
			pass
		State.ACTIVATED:
			pass


# =-------= 
# Rendering
# =-------=

func _construct_card():	
	# Set colours
	enemy_border.self_modulate = enemy_attributes["colour"]
	enemy_class.add_color_override("font_color", enemy_attributes["colour"])
	
	# Set text
	var enemy_firstname = enemy_properties.possible_first_names[rng.randi() % enemy_properties.possible_first_names.size()]
	var enemy_lastname = enemy_properties.possible_last_names[rng.randi() % enemy_properties.possible_last_names.size()]
	
	enemy_name.set_text(enemy_firstname + " " + enemy_lastname)
	enemy_class.set_text(enemy_attributes["class"])
	rect_scale = Vector2(0.01, 0.01)


func _update_attribute_text(current_attribute: float, target_attribute: float, label: Label) -> float:
	current_attribute = lerp(current_attribute, target_attribute, panel_update_rate)
	label.set_text("%.0f" % current_attribute + "%")
	return current_attribute


# =-------=
# Game Flow
# =-------=

func determine_next_turn_line(method_name) -> void:
	var turn_text = " "
	
	
	_add_next_turn_line(turn_text)


func _add_next_turn_line(text: String):
	var new_label = Label.new()
	new_label.set_text(" " + text)
	new_label.autowrap = true
	new_label.set_h_size_flags(SIZE_EXPAND)
	var effect_label_font = preload("res://fonts/enemy_effect_list.tres")
	new_label.add_font_override("font", effect_label_font)
	next_turn_effect_list.add_child(new_label)


func make_selectable():
	selectable = true


# =------------------------------=
# Enemy Control (State management)
# =------------------------------=

func _on_Focus_pressed() -> void:
	match state:
		State.FOCUSED, State.FOCUSING:
			SignalBus.emit_signal("enemy_chosen_for_play", self)


func _on_Focus_mouse_entered() -> void:
	match state:
		State.INACTIVE:
			if mouseover_enabled:
				_focus()


func _on_Focus_mouse_exited() -> void:
	pass
#	match state:
#		State.FOCUSED:
#			_unfocus()


func _focus():
	target_position = get_viewport_rect().size * FOCUS_POSITION - rect_pivot_offset
	target_rotation = 0
	target_scale = Vector2(1.2, 1.2)
	state = State.FOCUSING
	SignalBus.emit_signal("enemy_focusing", self)


func _unfocus():
	target_position = row_position
	target_rotation = row_rotation
	target_scale = row_scale
	focus_button.disabled = true
	state = State.SENDING_TO_ROW


func _check_focus(enemy):
	if enemy != self and (state == State.FOCUSED or state == State.FOCUSING):
		_unfocus()


func _on_BaseEnemy_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed(GameControl.primary_action):
		match state:
			State.INACTIVE:
				_focus()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(GameControl.secondary_action):
		match state:
			State.FOCUSED, State.FOCUSING:
				_unfocus()

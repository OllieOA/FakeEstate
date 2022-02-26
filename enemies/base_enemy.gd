extends MarginContainer
class_name BaseEnemy

enum State {
	INACTIVE,
	ACTIVATING,
	ACTIVE,
	DEACTIVATING,
	FOCUSING,
	FOCUSED,
	RETURNING
}


export (NodePath) onready var card_border = get_node(card_border) as NinePatchRect

export (NodePath) onready var enemy_name = get_node(enemy_name) as Label
export (NodePath) onready var enemy_class = get_node(enemy_class) as Label

export (NodePath) onready var aggro_number = get_node(aggro_number) as Label
export (NodePath) onready var nerve_number = get_node(nerve_number) as Label
export (NodePath) onready var fatigue_number = get_node(fatigue_number) as Label
export (NodePath) onready var fold_number = get_node(fold_number) as Label

export (NodePath) onready var next_turn_effect_list = get_node(next_turn_effect_list) as VBoxContainer

export (Resource) onready var enemy_properties = enemy_properties as EnemyProperties
export (EnemyProperties.Type) var enemy_type

onready var enemy_attributes = enemy_properties.enemy_database[enemy_type]


func _ready() -> void:
	_construct_card()
	
	
func _construct_card():
	pass
	
	# Set colours
	
	# Set text

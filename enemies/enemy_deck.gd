extends Resource
class_name EnemyDeck

const base_enemy = preload("res://enemies/base_enemy.tscn")

# These are DATA OBJECTS ONLY, all actual card instance drawing is handled
# in the bidding scene. Methods in this resource only move around the data
var current_enemies := []  # Arrays of type enums
var current_trash := []

var possible_enemies := EnemyProperties.Type.keys()

var rng = RandomNumberGenerator.new()

func initialize(num_enemies: int) -> void:
	rng.randomize()
	draw_up_to(num_enemies)


func draw_up_to(num_enemies: int) -> void:
	for _i in range(num_enemies):
		var new_enemy = draw()
		current_enemies.append(new_enemy)
		yield(SignalBus, "enemy_row_repositioned")


func draw():
	var base_enemy_instance = base_enemy.instance()
	var index_choice = rng.randi() % EnemyProperties.Type.size()
#	var enemy_choice = possible_enemies.pop_at(index_choice)
	var enemy_choice = EnemyProperties.Type.TIMEBOMB
	base_enemy_instance.enemy_type = enemy_choice
	
	SignalBus.emit_signal("enemy_drawn", base_enemy_instance)
	return base_enemy_instance


func trash_enemy(enemy_type: int, index=-1) -> void:
	if index == -1:
		# Find card manually
		index = current_enemies.find(enemy_type)
		
	current_enemies.pop_at(index)
	current_trash.append(enemy_type)

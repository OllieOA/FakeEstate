extends Node2D
# class_name GameControl (AutoLoaded)

export (NodePath) onready var animation_player = get_node(animation_player) as AnimationPlayer
export (NodePath) onready var music_audio = get_node(music_audio) as AudioStreamPlayer
export (NodePath) onready var music_fade = get_node(music_fade) as AnimationPlayer

# Handles elements of the overall game. Does not handle card logic

var active_player

var primary_action = "left_click"
var secondary_action = "right_click"

var current_scene
var current_scene_name
var following_scene


func _ready() -> void:
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
	animation_player.play_backwards("Fade")


func goto_scene(path, speed=1):
	following_scene = path
	animation_player.playback_speed = speed
	animation_player.play("Fade")
	
	
func process_scene_transition(path):
	current_scene.queue_free()
	var new_scene = ResourceLoader.load(path)
	current_scene = new_scene.instance()
	
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	animation_player.play_backwards()
	
	
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	# Only transition once animation has completed
	if GameControl.following_scene != null:
		call_deferred("process_scene_transition", GameControl.following_scene)
	GameControl.following_scene = null

extends Control

onready var settings_menu = $CanvasLayer/SettingsMenu
onready var settings_button = $CanvasLayer/SettingIconMargin/SettingsButton
onready var sfx_toggle = $CanvasLayer/SettingsMenu/SettingButtons/ToggleSFX
onready var music_toggle = $CanvasLayer/SettingsMenu/SettingButtons/ToggleMusic
onready var mouse_toggle = $CanvasLayer/SettingsMenu/SettingButtons/ToggleMouse
onready var settings_tooltip = $CanvasLayer/SettingIconMargin/SettingsButton/SettingsLabelBase
onready var mouse_flipper = $CanvasLayer/SettingsMenu/SettingButtons/ToggleMouse
onready var sfx_bus_id = AudioServer.get_bus_index("SFX")
onready var music_bus_id = AudioServer.get_bus_index("Music")
onready var menu_clicker = $MenuClick
onready var screen_fade = $CanvasLayer/ColorRect
onready var screen_fade_animator = $CanvasLayer/ColorRect/Fading

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings_tooltip.hide()
	settings_menu.hide()
	settings_menu.mouse_filter = 2


func _process(_delta: float) -> void:
	if GameControl.primary_action == "right_click":
		if music_toggle.get_button_mask() == 1:
			music_toggle.set_button_mask(2)
		if mouse_toggle.get_button_mask() == 1:
			mouse_toggle.set_button_mask(2)
		if sfx_toggle.get_button_mask() == 1:
			sfx_toggle.set_button_mask(2)
		if settings_button.get_button_mask() == 1:
			settings_button.set_button_mask(2)
	else:
		if music_toggle.get_button_mask() == 2:
			music_toggle.set_button_mask(1)
		if mouse_toggle.get_button_mask() == 2:
			mouse_toggle.set_button_mask(1)
		if sfx_toggle.get_button_mask() == 2:
			sfx_toggle.set_button_mask(1)
		if settings_button.get_button_mask() == 2:
			settings_button.set_button_mask(1)
		

func _on_SettingsButton_mouse_entered() -> void:
	settings_tooltip.show()


func _on_SettingsButton_mouse_exited() -> void:
	if not settings_button.pressed:
		settings_tooltip.hide()


func _on_ToggleSFX_pressed() -> void:
	menu_clicker.play()
	AudioServer.set_bus_mute(sfx_bus_id, not AudioServer.is_bus_mute(sfx_bus_id))


func _on_ToggleMusic_pressed() -> void:
	menu_clicker.play()
	AudioServer.set_bus_mute(music_bus_id, not AudioServer.is_bus_mute(music_bus_id))


func _on_ToggleMouse_pressed() -> void:
	menu_clicker.play()
	if mouse_flipper.pressed:
		GameControl.primary_action = "right_click"
		GameControl.secondary_action = "left_click"
	else:
		GameControl.primary_action = "left_click"
		GameControl.secondary_action = "right_click"


func _on_SettingsButton_pressed() -> void:
	if settings_button.pressed:
		screen_fade_animator.play("Fade")
		if GameControl.current_scene_name != "TitleScreen":
			get_tree().paused = true
			GameControl.music_fade.play("FadeIn")
	else:
		screen_fade_animator.play_backwards("Fade")
		if GameControl.current_scene_name != "TitleScreen":
			get_tree().paused = false
			GameControl.music_fade.play("FadeOut")
	menu_clicker.play()
	settings_menu.visible = !settings_menu.visible
	if settings_menu.visible:
		settings_menu.set_mouse_filter(0)
	else:
		settings_menu.set_mouse_filter(2)


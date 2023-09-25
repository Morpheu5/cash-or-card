extends Node2D

var intro_scene = preload("res://game_scenes/Intro.tscn")
var shop_scene = preload("res://game_scenes/shop.tscn")
var credits_scene = preload("res://game_scenes/credits.tscn")

func _ready():
	pass

func _on_start_button_pressed():
	var s = intro_scene.instantiate()
	s.modulate = Color(1,1,1,0)
	s.connect("start_button_pressed", _on_intro_start_button_pressed)
	add_child(s)
	await create_tween().tween_property(s, 'modulate', Color(1,1,1,1), 1).finished


func _on_credits_button_pressed():
	var s = credits_scene.instantiate()
	s.modulate = Color(1,1,1,0)
	add_child(s)
	await create_tween().tween_property(s, 'modulate', Color(1,1,1,1), 1).finished


func _on_intro_start_button_pressed():
	get_tree().change_scene_to_packed(shop_scene)


func set_locale(locale):
	TranslationServer.set_locale(locale)


func _on_button_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	pass # Replace with function body.

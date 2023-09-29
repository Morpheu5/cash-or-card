extends Node2D

var intro_scene = preload("res://game_scenes/Intro.tscn")
var shop_scene = preload("res://game_scenes/shop.tscn")
var credits_scene = preload("res://game_scenes/credits.tscn")
var privacy_scene = preload("res://game_scenes/Privacy.tscn")

func _ready():
	var date = Time.get_datetime_dict_from_system()
	Globals.participant_id = "%02d%02d%02d%02d%02d%02d" % [date.year-2000, date.month, date.day, date.hour, date.minute, date.second ]
	Globals.participant_id_string = "%02d %02d %02d %02d %02d %02d" % [date.year-2000, date.month, date.day, date.hour, date.minute, date.second ]
	%ParticipantID.text = Globals.participant_id_string
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


func _on_fs_button_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	pass # Replace with function body.



func _on_privacy_button_pressed():
	var s = privacy_scene.instantiate()
	s.modulate = Color(1,1,1,0)
	add_child(s)
	await create_tween().tween_property(s, 'modulate', Color(1,1,1,1), 1).finished

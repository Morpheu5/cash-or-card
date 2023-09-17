extends Node2D

var shop_scene = preload("res://game_scenes/shop.tscn")

func _ready():
	pass

func _on_start_button_pressed():
	await create_tween().tween_property($CanvasLayer/Blackout, 'modulate', Color(1, 1, 1, 1), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).finished
	get_tree().change_scene_to_packed(shop_scene)

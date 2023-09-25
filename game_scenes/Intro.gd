extends Node2D

signal start_button_pressed

func _ready():
	$CutscenePlayer.play("RESET")
	$CutscenePlayer.play("cutscene_01")

func _on_next_button_pressed():
	$CutscenePlayer.play("cutscene_02")

func _on_start_button_pressed():
	var t = create_tween()
	t.tween_property($BGMusicPlayer, 'volume_db', -40, 0.5)
	t.chain().tween_callback(func(): start_button_pressed.emit())
	var u = create_tween()
	u.tween_property($CanvasLayer/Scene02, 'modulate', Color(1,1,1,0), 0.5)


func _on_skip_button_pressed():
	$CutscenePlayer.stop()
	var t = create_tween()
	t.tween_property($BGMusicPlayer, 'volume_db', -40, 0.25)
	t.chain().tween_callback(func(): start_button_pressed.emit())
	var u = create_tween()
	u.tween_property($CanvasLayer/Scene01, 'modulate', Color(1,1,1,0), 0.25)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_PERIOD:
			$CutscenePlayer.advance(1000)
	elif event is InputEventMouseButton:
		if event.pressed:
			$CutscenePlayer.advance(1000)

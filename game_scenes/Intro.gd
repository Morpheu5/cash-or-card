extends Node2D

signal start_button_pressed

func _ready():
	$CutscenePlayer.play("RESET")
	$CutscenePlayer.play("cutscene_01")

func _on_next_button_pressed():
	$CutscenePlayer.play("cutscene_02")

func _on_start_button_pressed():
	start_button_pressed.emit()


func _on_skip_button_pressed():
	$CutscenePlayer.stop()
	start_button_pressed.emit()

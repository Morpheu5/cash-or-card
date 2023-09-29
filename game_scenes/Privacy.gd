extends Node2D

@onready var richtext = $Canvas/MarginContainer/RichTextLabel

func _ready():
	richtext.text = tr(richtext.text) % [Globals.participant_id_string]

func _on_back_button_pressed():
	queue_free()

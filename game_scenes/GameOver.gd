extends Node2D

@export var victory: bool

@onready var victoryText = tr("""
[center]Complimenti! Con %.2f soldi riesci a saldare il debito e pagare la rata dell'assicurazione!
[/center]
""")

@onready var gameOverText = tr("""
[center]Oh no! Hai un totale di %.2f soldi in banca ma la rata dell'assicurazione ti ha impedito di saldare il debito!
[/center]
""")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.victory = Globals.final_money >= 10000

	if victory:
		%TitleLabel.text = tr("Vittoria!")
		%InfoText.text = victoryText % Globals.bank_money
	else:
		%TitleLabel.text = tr("Game Over!")
		%InfoText.text = gameOverText % Globals.bank_money

func _on_survey_button_pressed():
	var locale = TranslationServer.get_locale()
	var u = ""
	if locale == "it_IT" or locale == "it":
		u = "https://qualtricsxmfv525fqw4.qualtrics.com/jfe/form/SV_6im4rtDltNhqjFY?PID=%s" % Globals.participant_id
	else:
		u = "https://qualtricsxmfv525fqw4.qualtrics.com/jfe/form/SV_9Ahy56rr3zyUVdc?PID=%s" % Globals.participant_id
	print(u)
	OS.shell_open(u)

func _on_back_to_title_button_pressed():
	get_tree().change_scene_to_file("res://game_scenes/title.tscn")

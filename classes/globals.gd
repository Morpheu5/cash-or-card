extends Node2D

var participant_id: String = ""
var participant_id_string: String = ""

var customer_names = ["Leonardo","Alessandro","Tommaso","Francesco","Lorenzo","Edoardo","Mattia","Riccardo","Gabriele","Andrea","Diego","Matteo","Nicolo","Giuseppe","Antonio","Federico","Pietro","Samuele","Giovanni","Filippo","Enea","Davide","Christian","Gioele","Giulio","Michele","Marco","Gabriel","Elia","Luca","Salvatore","Vincenzo","Emanuele","Thomas","Alessio","Giacomo","Nathan","Liam","Simone","Samuel","Jacopo","Noah","Daniele","Giorgio","Ettore","Luigi","Daniel","Manuel","Nicola","Damiano","Sofia","Aurora","Giulia","Ginevra","Beatrice","Alice","Vittoria","Emma","Ludovica","Matilde","Giorgia","Camilla","Chiara","Anna","Bianca","Nicole","Gaia","Martina","Greta","Azzurra","Sara","Arianna","Noemi","Rebecca","Mia","Isabel","Adele","Chloe","Elena","Francesca","Gioia","Ambra","Viola","Carlotta","Cecilia","Diana","Alessia","Elisa","Emily","Marta","Maria","Margherita","Anita","Giada","Eleonora","Nina","Miriam","Asia","Amelia","Diletta"]

var payment_methods = {
	"cash": { "method_id": "cash",
	  "electronic": false,
	  "fee_threshold": 0,
	  "low_fee": 0.00,
	  "high_fee": 0.00,
	},
	"card": { "method_id": "card",
	  "electronic": true,
	  "fee_threshold": randi_range(5, 20),
	  "low_fee": snapped(randf_range(0.0, 0.015), 0.001),
	  "high_fee": snapped(randf_range(0.015, 0.02), 0.001),
	},
	"payup": { "method_id": "payup",
	  "electronic": true,
	  "fee_threshold": randi_range(10, 50),
	  "low_fee": snapped(randf_range(0.0, 0.015), 0.001),
	  "high_fee": snapped(randf_range(0.015, 0.02), 0.001),
	},
	"oddlypay": { "method_id": "oddlypay",
	  "electronic": true,
	  "fee_threshold": randi_range(10, 50),
	  "low_fee": snapped(randf_range(0.0, 0.015), 0.001),
	  "high_fee": snapped(randf_range(0.015, 0.02), 0.001),
	},
}

const victory_threshold = 10000
var final_money = 0.0
var bank_money = 0.0
var insurance_premium = 0.0
var victory = false

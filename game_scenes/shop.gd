extends BaseDialogueTestScene

@onready var Globals = get_node("/root/Globals")
@onready var main_dialog = preload("res://main.dialogue")

signal cash_changed(new_value)
signal bank_changed(new_value)
signal insurance_premium_changed(new_value)
signal insurance_excess_changed(new_value)
signal income_lost_changed(new_value)
signal robbery_chance_changed(new_value)
signal electronic_fee_loss_changed(new_value)
signal cash_fee_loss_changed(new_value)

var payment_methods = [
	{ "method_id": "cash",
	  "text": "in contanti",
	  "electronic": false,
	  "fee_threshold": 0,
	  "low_fee": 0.00,
	  "high_fee": 0.00,
	},
	{ "method_id": "card",
	  "text": "con la carta",
	  "electronic": true,
	  "fee_threshold": randi_range(5, 20),
	  "low_fee": 0.01,
	  "high_fee": 0.005,
	},
	{ "method_id": "payup",
	  "text": "con PayUp",
	  "electronic": true,
	  "fee_threshold": randi_range(10, 50),
	  "low_fee": 0.01,
	  "high_fee": snapped(randf_range(0.015, 0.04), 0.01),
	},
	{ "method_id": "oddlypay",
	  "text": "con OddlyPay",
	  "electronic": true,
	  "fee_threshold": randi_range(10, 50),
	  "low_fee": 0.01,
	  "high_fee": snapped(randf_range(0.015, 0.04), 0.01),
	},
]

var payment_method = null
var amount = 0.0
var customer: Customer = null
var bank = 0.0:
	set(value):
		bank_changed.emit(value)
		bank = value
var bank_cash_fee = snapped(randf_range(0.02, 0.04), 0.01)
var cash = 0.0:
	set(value):
		cash_changed.emit(value)
		cash = value
var electronic_offered = false

var robbery_chance = 0.0:
	set(value):
		robbery_chance_changed.emit(value)
		robbery_chance = value

var stolen_cash = 0.0
var insurance_premium:
	set(value):
		insurance_premium_changed.emit(value)
		insurance_premium = value
var insurance_excess:
	set(value):
		insurance_excess_changed.emit(value)
		insurance_excess = value
var insurance_refund = 0.0

var income_lost = 0.0:
	set(value):
		income_lost_changed.emit(value)
		income_lost = value

var electronic_fee_loss = 0.0:
	set(value):
		electronic_fee_loss_changed.emit(value)
		electronic_fee_loss = value

var cash_fee_loss = 0.0:
	set(value):
		cash_fee_loss_changed.emit(value)
		cash_fee_loss = value

var customers: Array[Customer] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bank = 0.0
	cash = 0.0
	insurance_premium = randi_range(300, 500)
	insurance_excess = randi_range(100, 200)
	income_lost = 0.0
	electronic_fee_loss = 0.0
	cash_fee_loss = 0.0
	run()
	
func run():
	initialize_day()
	loop()

func initialize_day():
	stolen_cash = 0.0
	insurance_refund = 0.0
	update_robbery_chance()
	for i in randi_range(5, 15):
		customers.append(Customer.new() \
			.set_name(Globals.customer_names[randi() % Globals.customer_names.size()]))

func loop() -> void:
	update_robbery_chance()
	if randf() < robbery_chance:
		stolen_cash = cash
		DialogueManager.show_example_dialogue_balloon(main_dialog, "shop_robbery")
		customers = []
	elif not customers.is_empty():
		customer = customers.pop_front()
		select_payment_method(customer)
		amount = snapped(randf_range(0.05, 100.0), 0.01)
		electronic_offered = false
		
#		print()
#		print("Bank: ", bank, "\tCash: ", cash)
#		print("Amount: ", amount)
#		print("Thresh: ", payment_method.fee_threshold)
#		print("Customer: ", customer)
		
		DialogueManager.show_example_dialogue_balloon(main_dialog, "main")
	else:
		if cash > 0.0:
			DialogueManager.show_example_dialogue_balloon(main_dialog, "ask_bank_run")

func update_robbery_chance():
	robbery_chance = 0.005 + cash / 10000

func handle_payment(c: Customer, p: Dictionary):
	var fee = p["low_fee"] if amount < p["fee_threshold"] else p["high_fee"]
	if (p["method_id"] == "cash"):
		cash = snapped(cash + amount, 0.01)
	else:
		bank = snapped(bank + amount * (1 - fee), 0.01)
		electronic_fee_loss += amount * fee

func handle_bank_run():
	if randf() < robbery_chance:
		stolen_cash = cash
		DialogueManager.show_example_dialogue_balloon(main_dialog, "street_robbery")
	else:
		bank = snapped(bank + cash * (1 - bank_cash_fee), 0.01)
		cash_fee_loss += snapped(cash * bank_cash_fee, 0.01)
		DialogueManager.show_example_dialogue_balloon(main_dialog, "end_bank_run")
	cash = 0.0

func handle_insurance_claim(amount: float = 0.0):
	insurance_refund = max(0, stolen_cash - insurance_excess)
	
	bank = snapped(bank + insurance_refund * (1 - bank_cash_fee), 0.01)
	cash_fee_loss += snapped(insurance_refund * bank_cash_fee, 0.01)
	cash = 0.0
	
	insurance_premium = ceili(insurance_premium * 1.05)
	insurance_excess = ceili(insurance_excess * 1.05)

func handle_income_loss():
	income_lost = snapped(income_lost + amount, 0.01)

func select_payment_method(c: Customer):
	if c.prefers_cash > 1 || c.must_use_cash || c.denial_tolerance == 0:
		payment_method = payment_methods[0]
	else:
		payment_method = payment_methods[(randi() % (payment_methods.size() - 1)) + 1]
	c.set_payment_method(payment_method)

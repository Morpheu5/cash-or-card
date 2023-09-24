extends BaseDialogueTestScene

const Balloon = preload("res://game_scenes/balloon/balloon.tscn")
const Walker = preload("res://game_scenes/walker.tscn")

@onready var Globals = get_node("/root/Globals")
@onready var main_dialog: DialogueResource = preload("res://assets/main.dialogue")

@onready var customerNameLabel = $HUD/%CustomerNameLabel
@onready var customerPicture = $HUD/%CustomerPicture
@onready var amountLabel = $HUD/%AmountLabel

@onready var shopFloor = $HUD/%ShopFloor

var customerLine: Array[Node2D] = []
var firstCustomer = true

signal customer_debug

signal cash_changed(new_value)
signal bank_changed(new_value)
signal insurance_premium_changed(new_value)
signal insurance_excess_changed(new_value)
signal income_lost_changed(new_value)
signal robbery_chance_changed(new_value)
signal electronic_fee_loss_changed(new_value)
signal cash_fee_loss_changed(new_value)

var payment_method = null
var amount = 0.0
var amount_str = "0,00"
var customer: Customer = null
var electronic_offered = false
var customer_has_explained_conspiracy = false

var bank = 18000.0:
	set(value):
		bank_changed.emit(value)
		bank = value
var bank_cash_fee = snapped(randf_range(0.02, 0.04), 0.01)

var cash = 0.0:
	set(value):
		cash_changed.emit(value)
		cash = value

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

var potential_loss = 0.0

var customers: Array[Customer] = []

var lights = false

var day = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bank = 18000.0
	cash = 0.0
	insurance_premium = randi_range(100, 200)
	insurance_excess = randi_range(50, 100)
	income_lost = 0.0
	electronic_fee_loss = 0.0
	cash_fee_loss = 0.0
	customer_has_explained_conspiracy = false
	
	customer_debug.connect(do_customer_debug)
	
	$HUD/Blackout.color = Color(0, 0, 0, 1)
	$HUD/Blackout.visible = true
	$HUD/%InfoPanel.modulate = Color(1, 1, 1, 0)
	hide_day_card()
	
	var day_card = get_node("HUD/DayCard")
	day_card.open_shop_button_pressed.connect(_on_open_shop_button_pressed)
	
	run()

func _on_open_shop_button_pressed():
	# Now get this show started
	await hide_day_card()
	await lights_on()
	radio_on()
	loop()

func do_customer_debug():
	print(customer.to_string())

func lights_out():
	await create_tween().tween_property($HUD/Blackout, 'color', Color(0, 0, 0, 1), 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO).finished
	await create_tween().tween_property($HUD/%InfoPanel, 'modulate', Color(1, 1, 1, 0), 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO).finished
	lights = false

func lights_on():
	await create_tween().tween_property($HUD/Blackout, 'color', Color(0, 0, 0, 0), 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO).finished
	lights = true

func hide_day_card():
	if $HUD/DayCard.visible:
		await create_tween().tween_property($HUD/DayCard, 'modulate', Color(1, 1, 1, 0), 0.25).finished
		$HUD/DayCard.visible = false

func show_day_card():
	if !$HUD/DayCard.visible:
		await create_tween().tween_property($HUD/DayCard, 'modulate', Color(1, 1, 1, 1), 0.25).finished
		$HUD/DayCard.visible = true

func radio_off(sudden: bool = false):
	if sudden:
		await create_tween().tween_property($AudioStreamPlayer, 'volume_db', -40, 0.1).finished
	else:
		await create_tween().tween_property($AudioStreamPlayer, 'volume_db', -40, 2).finished
	$AudioStreamPlayer.playing = false

func radio_on():
	$AudioStreamPlayer.volume_db = -80
	$AudioStreamPlayer.playing = true
	create_tween().tween_property($AudioStreamPlayer, 'volume_db', -12, 0.1)
	
func run():
	await initialize_day()

func initialize_day():
	# Emergency curtain
	if lights:
		await lights_out()
	
	day += 1
	
	# Remove any leftover customers wandering out of the shop
	for c in $HUD/%ShopFloor/ColorRect/QueueStartEmpty.get_children():
		$HUD/%ShopFloor/ColorRect/QueueStartEmpty.remove_child(c)

	# Initialize all the values to sensible start-of-day defaults
	stolen_cash = 0.0
	insurance_refund = 0.0
	potential_loss = 0.0
	firstCustomer = true
	update_robbery_chance()
	
	# Roll the dice
	randomize()

	# Shuffle the list of names so we get fresh customers in a new order every day
	var shuffled_names = Globals.customer_names
	shuffled_names.shuffle()
	# Then generate the line
	for i in randi_range(5,10): #TODO Change the range for production
		var c = Customer.new().set_name(shuffled_names.pop_front())
		# if c.must_use_cash:
		# 	c.set_name(c.name + " (W)")
		customers.append(c)
	# And add the corresponding sprites in the right place
	for i in customers.size():
		var customer_node = Walker.instantiate()
		var customer_sprite = customer_node.get_node('Sprite')
		var empty = shopFloor.get_node('ColorRect/QueueStartEmpty')
		var sprite_size = customer_sprite.texture.get_size()
		var sprite_scale = customer_sprite.get_scale()
		customer_node.position.x = -sprite_size.x/2 * (i+0.5)
		customer_node.position.y = -sprite_size.y * sprite_scale.y
		empty.add_child(customer_node)
		customerLine.append(customer_node)
	
	# Show new day info and current stats
	$HUD/DayCard/%TitleLabel.text = tr("Giorno %d") % day
	$HUD/DayCard/%BankLabel.text = tr("Banca: %.2f") % bank
	$HUD/DayCard/%CashLabel.text = tr("Contanti: %.2f") % cash
	$HUD/DayCard/%ElectronicFeeLossLabel.text = tr("Costi elettronici: %.2f") % electronic_fee_loss
	$HUD/DayCard/%CashFeeLossLabel.text = tr("Costi contanti: %.2f") % cash_fee_loss
	$HUD/DayCard/%InsurancePremiumLabel.text = tr("Assicurazione: %.2f") % insurance_premium
	$HUD/DayCard/%InsuranceExcessLabel.text = tr("Franchigia: %.2f") % insurance_excess
	$HUD/DayCard/%IncomeLossLabel.text = tr("Mancati guadagni: %.2f") % income_lost
	$HUD/DayCard/%RobberyChanceLabel.text = tr("Rischio rapina: %.1f %%") % (robbery_chance * 100)
	await show_day_card()

func start_dialogue(res: DialogueResource, chap: String):
	var balloon: Node = Balloon.instantiate()
	balloon.set_display_folded(true)
	add_child(balloon)
	balloon.start(res, chap)
	return balloon


func show_info_panel():
	await create_tween().tween_property($HUD/%InfoPanel, 'modulate', Color(1, 1, 1, 1), 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT).finished

func hide_info_panel():
	await create_tween().tween_property($HUD/%InfoPanel, 'modulate', Color(1, 1, 1, 0), 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT).finished

func loop() -> void:
	update_robbery_chance()
	
	if not firstCustomer:
		customer_walks_away()
		line_moves_on()
	firstCustomer = false
	
	if not customers.is_empty():
		await hide_info_panel()
		await new_customer()
	else:
		await end_of_day()

func new_customer():
	customer = customers.pop_front()
	customerNameLabel.text = customer.name
	customerPicture.texture = load("res://assets/faces/%s.png" % customer.name)
	
	customer_has_explained_conspiracy = false
	select_payment_method(customer)
	amount = snapped(randf_range(0.05, 100.0), 0.01)
	amount_str = ("%.2f" % amount).replace(".", ",")
	amountLabel.text = tr("Totale: %s") % amount_str
	electronic_offered = false
	await show_info_panel()
	
	start_dialogue(main_dialog, "main")

func customer_walks_away():
	var customer_node = customerLine.pop_front()
	var customer_sprite: Sprite2D = customer_node.get_node('Sprite')
	var customer_tween = create_tween()
	customer_tween.tween_property(customer_node, 'global_position', Vector2(-100, customer_node.global_position.y), 9)
	customer_node.scale.x = -1
	customer_node.global_position.x += customer_sprite.texture.get_width() / 3
	customer_node.global_position.y -= 20
	var customer_ap: AnimationPlayer = customer_node.get_node('AnimationPlayer')
	customer_ap.set_speed_scale(1.0)
	customer_ap.play('walking')
	await create_tween().tween_property($HUD/%InfoPanel, 'modulate', Color(1, 1, 1, 0), 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT).finished

func line_moves_on():
	for i in customerLine.size():
		var c_tween = create_tween()
		var c = customerLine[i]
		var c_sprite = c.get_node('Sprite')
		var ap = c.get_node('AnimationPlayer')
		ap.set_speed_scale(0.2)
		ap.play('walking')
		c_tween.tween_property(c, 'global_position', c.global_position + Vector2(c_sprite.texture.get_size().x/2, 0), randf_range(0.5, 1.5)).set_delay(0.25*i)
		c_tween.tween_callback(func(): c.get_node('AnimationPlayer').play('standing'))

func end_of_day():
	await create_tween().tween_property($HUD/%InfoPanel, 'modulate', Color(1, 1, 1, 0), 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT).finished
	if randf() < robbery_chance:
		radio_off(true)
		# TODO Add robbery stinger
		stolen_cash = cash
		potential_loss = max(0, stolen_cash - insurance_excess)
		start_dialogue(main_dialog, "shop_robbery")
		customers = []
	elif cash > 0.0:
		start_dialogue(main_dialog, "ask_bank_run")
	else:
		await radio_off()
		run()

func update_robbery_chance():
	robbery_chance = 0.005 + cash / 10000

func handle_payment(method: String):
	var fee = get_fee(method, amount)
	if (method == "cash"):
		cash = snapped(cash + amount, 0.01)
	else:
		bank = snapped(bank + amount * (1 - fee), 0.01)
		electronic_fee_loss += amount * fee

func get_fee(method: String, _amount: float):
	var p = Globals.payment_methods[method]
	var fee = p["low_fee"] if _amount < p["fee_threshold"] else p["high_fee"]
	return fee

func handle_bank_run():
	if randf() < robbery_chance:
		stolen_cash = cash
		potential_loss = max(0, stolen_cash - insurance_excess)
		start_dialogue(main_dialog, "street_robbery")
	else:
		bank = snapped(bank + cash * (1 - bank_cash_fee), 0.01)
		cash_fee_loss += snapped(cash * bank_cash_fee, 0.01)
		start_dialogue(main_dialog, "end_bank_run")
	cash = 0.0

func handle_insurance_claim():
	insurance_refund = max(0, stolen_cash - insurance_excess)
	bank = snapped(bank + insurance_refund * (1 - bank_cash_fee), 0.01)
	cash_fee_loss += snapped(insurance_refund * bank_cash_fee, 0.01)
	cash = 0.0
	insurance_premium = ceili(insurance_premium * 1.05)
	insurance_excess = ceili(insurance_excess * 1.05)

func handle_income_loss():
	income_lost = snapped(income_lost + amount, 0.01)

func select_payment_method(c: Customer):
	if c.prefers_cash > 1 || c.must_use_cash:
		c.set_payment_method("cash")
	else:
		c.set_payment_method("card")


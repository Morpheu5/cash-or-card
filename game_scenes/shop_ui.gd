extends CanvasLayer

@onready var bankLabel = $ShopUI/Panel/MarginContainer/VBoxContainer/BankLabel
@onready var cashLabel = $ShopUI/Panel/MarginContainer/VBoxContainer/CashLabel
@onready var insurancePremiumLabel = $ShopUI/Panel/MarginContainer/VBoxContainer/InsurancePremiumLabel
@onready var insuranceExcessLabel = $ShopUI/Panel/MarginContainer/VBoxContainer/InsuranceExcessLabel
@onready var incomeLossLabel = $ShopUI/Panel/MarginContainer/VBoxContainer/IncomeLossLabel
@onready var electronicFeeLossLabel = $ShopUI/Panel/MarginContainer/VBoxContainer/ElectronicFeeLossLabel
@onready var cashFeeLossLabel = $ShopUI/Panel/MarginContainer/VBoxContainer/CashFeeLossLabel
@onready var robberyChanceLabel = $ShopUI/Panel/MarginContainer/VBoxContainer/RobberyChanceLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	bankLabel.text = "Banca: 0.00"
	cashLabel.text = "Contanti: 0.00"
	insurancePremiumLabel.text = "Assicurazione: 0.00"
	insuranceExcessLabel.text = "Franchigia: 0.00"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_shop_bank_changed(new_value):
	bankLabel.text = "Banca: %.2f" % new_value

func _on_shop_cash_changed(new_value):
	cashLabel.text = "Contanti: %.2f" % new_value

func _on_shop_insurance_premium_changed(new_value):
	insurancePremiumLabel.text = "Assicurazione: %.2f" % new_value
	
func _on_shop_insurance_excess_changed(new_value):
	insuranceExcessLabel.text = "Franchigia: %.2f" % new_value

func _on_shop_income_lost_changed(new_value):
	incomeLossLabel.text = "Mancati guadagni: %.2f" % new_value

func _on_shop_electronic_fee_loss_changed(new_value):
	electronicFeeLossLabel.text = "Costi elettronici: %.2f" % new_value

func _on_shop_cash_fee_loss_changed(new_value):
	cashFeeLossLabel.text = "Costi contante: %.2f" % new_value

func _on_shop_robbery_chance_changed(new_value):
	print(new_value)
	robberyChanceLabel.text = "Rischio rapina: %d %%" % (new_value * 100)
